//
//  EvenementsView.swift
//  Organizer 
//
//  OBJECTIF
//  --------
//  Lister les evenements tries par date, avec navigation vers le
//  detail et ajout via une feuille modale.
//
//  CONCEPTS COUVERTS
//   - @Query(sort:), NavigationLink(value:), navigationDestination
//

import SwiftUI
import SwiftData

struct EvenementsView: View {
    @Environment(\.modelContext) private var context

    @Query(sort: \Evenement.dateEvenement) private var evenements: [Evenement]

    @State private var afficherAjout = false

    var body: some View {
        Group {
            if evenements.isEmpty {
                ContentUnavailableView("Aucun evenement", systemImage: "calendar.badge.plus",
                                        description: Text("Ajoutez votre premier evenement a organiser."))
            } else {
                List {
                    ForEach(evenements) { evenement in
                        NavigationLink(value: evenement) {
                            EvenementRow(evenement: evenement)
                        }
                    }
                    .onDelete(perform: supprimer)
                }
            }
        }
        .navigationTitle("Evenements")
        .navigationDestination(for: Evenement.self) { evenement in
            EvenementDetailView(evenement: evenement)
        }
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
            AjouterEvenementView()
        }
    }

    private func supprimer(at offsets: IndexSet) {
        for index in offsets {
            context.delete(evenements[index])
        }
    }
}

private struct EvenementRow: View {
    let evenement: Evenement

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: evenement.type.symbole)
                .font(.title2)
                .foregroundStyle(.indigo)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(evenement.nom).font(.headline)
                Text(evenement.dateEvenement, format: .dateTime.day().month().year())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(evenement.lieu)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
    }
}

#Preview {
    NavigationStack {
        EvenementsView()
    }
    .modelContainer(PreviewContainer.preview)
}
