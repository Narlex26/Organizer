//
//  AjouterTacheView.swift
//  Organizer 
//
//  evenement == nil quand on ajoute depuis l'onglet "Taches" global :
//  l'evenement est alors choisi dans le formulaire via un Picker.
//

import SwiftUI
import SwiftData

struct AjouterTacheView: View {
    let evenement: Evenement?

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Evenement.dateEvenement) private var evenements: [Evenement]
    @Query(sort: \Contact.nom) private var contacts: [Contact]

    @State private var titre = ""
    @State private var dateLimite = Date.now.addingTimeInterval(3 * 24 * 3600)
    @State private var priorite: PrioriteTache = .normale
    @State private var evenementSelectionne: Evenement?
    @State private var assigneA: Contact?

    var body: some View {
        NavigationStack {
            Form {
                Section("Tache") {
                    TextField("Titre", text: $titre)
                    DatePicker("Date limite", selection: $dateLimite, displayedComponents: .date)
                    Picker("Priorite", selection: $priorite) {
                        ForEach(PrioriteTache.allCases) { p in
                            Text(p.rawValue).tag(p)
                        }
                    }
                }
                if evenement == nil {
                    Section("Evenement") {
                        Picker("Evenement", selection: $evenementSelectionne) {
                            Text("Aucun").tag(Evenement?.none)
                            ForEach(evenements) { e in
                                Text(e.nom).tag(Optional(e))
                            }
                        }
                    }
                }
                Section("Assignation") {
                    Picker("Assigner a", selection: $assigneA) {
                        Text("Personne").tag(Contact?.none)
                        ForEach(contacts) { c in
                            Text(c.nom).tag(Optional(c))
                        }
                    }
                }
            }
            .navigationTitle("Nouvelle tache")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") { ajouter() }
                        .disabled(titre.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func ajouter() {
        let cible = evenement ?? evenementSelectionne
        let nouvelle = Tache(titre: titre, dateLimite: dateLimite, priorite: priorite,
                              evenement: cible, assigneA: assigneA)
        context.insert(nouvelle)
        dismiss()
    }
}

#Preview {
    AjouterTacheView(evenement: PreviewContainer.exampleEvenement)
        .modelContainer(PreviewContainer.preview)
}
