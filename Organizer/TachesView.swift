//
//  TachesView.swift
//  Organizer 
//

import SwiftUI
import SwiftData

struct TachesView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Tache.dateLimite) private var taches: [Tache]

    @State private var afficherAjout = false

    private var groupes: [StatutTache: [Tache]] {
        Dictionary(grouping: taches, by: \.statut)
    }

    var body: some View {
        Group {
            if taches.isEmpty {
                ContentUnavailableView("Aucune tache", systemImage: "checklist",
                                        description: Text("Les taches apparaissent ici une fois ajoutees a un evenement."))
            } else {
                List {
                    ForEach(StatutTache.allCases) { statut in
                        if let tachesDuStatut = groupes[statut], !tachesDuStatut.isEmpty {
                            Section(statut.rawValue) {
                                ForEach(tachesDuStatut) { tache in
                                    TacheLigne(tache: tache)
                                        .swipeActions(edge: .leading) {
                                            Button {
                                                withAnimation {
                                                    tache.statut = tache.statut.suivant
                                                }
                                            } label: {
                                                Label("Avancer", systemImage: tache.statut.symbole)
                                            }
                                            .tint(.indigo)
                                        }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Taches")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    afficherAjout = true
                } label: {
                    Label("Ajouter", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $afficherAjout) {
            AjouterTacheView(evenement: nil)
        }
    }
}

private struct TacheLigne: View {
    let tache: Tache

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(tache.titre)
                if let nomEvenement = tache.evenement?.nom {
                    Text(nomEvenement).font(.caption).foregroundStyle(.secondary)
                }
            }
            Spacer()
            Text(tache.dateLimite, format: .dateTime.day().month())
                .font(.caption)
                .foregroundStyle(tache.enRetard ? .red : .secondary)
        }
    }
}

#Preview {
    NavigationStack {
        TachesView()
    }
    .modelContainer(PreviewContainer.preview)
}
