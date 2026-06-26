//
//  BudgetView.swift
//  Organizer 
//
//  OBJECTIF
//  --------
//  Visualiser la repartition des depenses par categorie avec Charts,
//  et la progression budgetaire de chaque evenement.
//
//  CONCEPTS COUVERTS
//   - Charts : Chart, BarMark, .foregroundStyle(.gradient)
//

import SwiftUI
import SwiftData
import Charts

struct BudgetView: View {
    @Query(sort: \Evenement.dateEvenement) private var evenements: [Evenement]
    @Query private var depenses: [Depense]

    private struct RepartitionLigne: Identifiable {
        let id: CategorieDepense
        let montant: Double
    }

    private var repartition: [RepartitionLigne] {
        repartitionDepensesParCategorie(depenses)
            .map { RepartitionLigne(id: $0.key, montant: $0.value) }
            .sorted { $0.montant > $1.montant }
    }

    var body: some View {
        Group {
            if depenses.isEmpty {
                ContentUnavailableView("Aucune depense", systemImage: "chart.bar",
                                        description: Text("Les depenses ajoutees aux evenements apparaitront ici."))
            } else {
                List {
                    // Repartition des depenses par categorie sous forme
                    // d'histogramme horizontal (BarMark), trie du plus
                    // gros au plus petit montant.
                    Section("Repartition par categorie") {
                        Chart(repartition) { ligne in
                            BarMark(
                                x: .value("Montant", ligne.montant),
                                y: .value("Categorie", ligne.id.rawValue)
                            )
                            .foregroundStyle(Color.indigo.gradient)
                            .annotation(position: .trailing, alignment: .leading) {
                                Text(ligne.montant, format: .currency(code: "EUR"))
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .chartXAxis(.hidden)
                        .frame(height: CGFloat(repartition.count) * 44 + 16)
                    }

                    Section("Budget par evenement") {
                        ForEach(evenements) { evenement in
                            BudgetEvenementRow(evenement: evenement)
                        }
                    }
                }
            }
        }
        .navigationTitle("Budget")
    }
}

private struct BudgetEvenementRow: View {
    let evenement: Evenement

    private var engage: Double {
        montantTotalDepenses(evenement.depenses)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(evenement.nom).font(.subheadline)
                Spacer()
                Text(engage, format: .currency(code: "EUR"))
                    .font(.subheadline.bold())
                    .foregroundStyle(engage > evenement.budgetPrevu ? .red : .primary)
            }
            ProgressView(value: min(engage / max(evenement.budgetPrevu, 1), 1.0))
                .tint(engage > evenement.budgetPrevu ? .red : .indigo)
        }
    }
}

#Preview {
    NavigationStack {
        BudgetView()
    }
    .modelContainer(PreviewContainer.preview)
}
