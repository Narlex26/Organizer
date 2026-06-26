//
//  EvenementDetailView.swift
//  Organizer 
//
//  OBJECTIF
//  --------
//  Vue de detail d'un evenement : invites (RSVP), taches (avec
//  cycle de statut), budget anime, et un export texte qui combine
//  SwiftData + Swift pur + presse-papiers.
//
//  CONCEPTS COUVERTS
//   - @Bindable, Picker lie a une propriete @Model
//   - swipeActions + withAnimation + enum.suivant
//   - ProgressView anime (.animation(value:))
//   - Generique elementsRecents + protocole Recapitulable (Module A)
//

import SwiftUI
import SwiftData
#if canImport(UIKit)
import UIKit
#endif

struct EvenementDetailView: View {
    @Bindable var evenement: Evenement
    @Environment(\.modelContext) private var context

    @State private var afficherAjoutInvite = false
    @State private var afficherAjoutTache = false
    @State private var recapCopie = false

    private var invitations: [Invitation] {
        evenement.invitations.sorted { ($0.contact?.nom ?? "") < ($1.contact?.nom ?? "") }
    }
    private var taches: [Tache] {
        evenement.taches.sorted { $0.dateLimite < $1.dateLimite }
    }

    private var budgetEngage: Double {
        montantTotalDepenses(evenement.depenses)
    }
    private var progressionBudget: Double {
        guard evenement.budgetPrevu > 0 else { return 0 }
        return budgetEngage / evenement.budgetPrevu
    }

    var body: some View {
        List {
            Section("Informations") {
                LabeledContent("Date") {
                    Text(evenement.dateEvenement, format: .dateTime.day().month().year())
                }
                LabeledContent("Lieu") { Text(evenement.lieu) }
                TextField("Notes", text: $evenement.notes, axis: .vertical)
            }

            // TODO 9 : afficher la progression du budget avec une
            //           ProgressView animee (value lie a
            //           `progressionBudget`, couleur differente si
            //           depassement).
            Section("Budget") {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(budgetEngage, format: .currency(code: "EUR"))
                            .fontWeight(.semibold)
                        Text("engages sur")
                            .foregroundStyle(.secondary)
                        Text(evenement.budgetPrevu, format: .currency(code: "EUR"))
                    }
                    .font(.subheadline)

                    ProgressView(value: 0) // a remplacer par `min(progressionBudget, 1.0)`
                }
            }

            // TODO 9 : afficher la liste des invites, chacun avec un
            //           Picker lie a `invitation.statut` (voir
            //           InvitationRow ci-dessous). Le header de la
            //           section doit afficher le taux de
            //           confirmation (via `tauxConfirmation`).
            Section("Invites (\(evenement.invitations.count))") {
                ForEach(invitations) { invitation in
                    InvitationRow(invitation: invitation)
                }
                Button {
                    afficherAjoutInvite = true
                } label: {
                    Label("Inviter un contact", systemImage: "person.badge.plus")
                }
            }

            // TODO 9 : permettre de faire avancer le statut d'une tache
            //           par un swipe (swipeActions), en utilisant
            //           `tache.statut.suivant` dans un
            //           `withAnimation`.
            Section("Taches (\(evenement.taches.count))") {
                ForEach(taches) { tache in
                    TacheRow(tache: tache)
                }
                .onDelete { offsets in
                    for index in offsets { context.delete(taches[index]) }
                }
                Button {
                    afficherAjoutTache = true
                } label: {
                    Label("Ajouter une tache", systemImage: "plus")
                }
            }

            Section {
                Button {
                    copierRecap()
                } label: {
                    Label(recapCopie ? "Recapitulatif copie !" : "Copier le recapitulatif",
                          systemImage: recapCopie ? "checkmark.circle.fill" : "doc.on.doc")
                }
            }
        }
        .navigationTitle(evenement.nom)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $afficherAjoutInvite) {
            AjouterInviteView(evenement: evenement)
        }
        .sheet(isPresented: $afficherAjoutTache) {
            AjouterTacheView(evenement: evenement)
        }
    }

    // TODO 11 : combiner `elementsRecents` (generique, Module A) et
    //           `recapTexte` (protocole Recapitulable, Module A) pour
    //           construire un texte recapitulatif des 5 taches les
    //           plus recentes, puis le copier dans le presse-papiers
    //           (UIPasteboard). Affiche une confirmation temporaire
    //           via `recapCopie`. Mobilise Module A (logique pure),
    //           Module B (etat SwiftUI) et SwiftData (evenement.taches
    //           vient d'une relation @Model) en une seule action.
    private func copierRecap() {
        // a implementer
    }
}

private struct InvitationRow: View {
    @Bindable var invitation: Invitation

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(invitation.contact?.nom ?? "Contact supprime")
                if invitation.plusUn {
                    Text("+ 1 accompagnant")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Text(invitation.statut.rawValue) // a remplacer par un Picker lie a $invitation.statut
                .foregroundStyle(invitation.statut.couleur)
        }
    }
}

private struct TacheRow: View {
    let tache: Tache

    var body: some View {
        HStack {
            Image(systemName: tache.statut.symbole)
                .foregroundStyle(tache.statut.couleur)
            VStack(alignment: .leading) {
                Text(tache.titre)
                    .strikethrough(tache.statut == .terminee)
                Text(tache.dateLimite, format: .dateTime.day().month())
                    .font(.caption)
                    .foregroundStyle(tache.enRetard ? .red : .secondary)
            }
            Spacer()
            Text(tache.priorite.rawValue)
                .font(.caption2)
                .padding(.horizontal, 6).padding(.vertical, 2)
                .background(tache.priorite.couleur.opacity(0.15), in: Capsule())
                .foregroundStyle(tache.priorite.couleur)
        }
    }
}

#Preview {
    NavigationStack {
        EvenementDetailView(evenement: PreviewContainer.exampleEvenement)
    }
    .modelContainer(PreviewContainer.preview)
}
