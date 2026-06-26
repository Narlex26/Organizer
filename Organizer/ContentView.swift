//
//  ContentView.swift
//  Organizer 
//
//  OBJECTIF
//  --------
//  Assembler les 3 sections de l'app dans une TabView.
//
//  CONCEPTS COUVERTS
//   - TabView, NavigationStack, tabItem
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        // 3 onglets, chacun dans son propre NavigationStack pour que la
        // navigation d'un onglet n'affecte pas les autres.
        TabView {
            NavigationStack {
                EvenementsView()
            }
            .tabItem {
                Label("Evenements", systemImage: "calendar")
            }

            NavigationStack {
                TachesView()
            }
            .tabItem {
                Label("Taches", systemImage: "checklist")
            }

            NavigationStack {
                BudgetView()
            }
            .tabItem {
                Label("Budget", systemImage: "eurosign.circle")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(PreviewContainer.preview)
}

// IDEE A RETENIR
// --------------
// TabView se contente d'empiler des vues : chaque onglet a sa propre
// NavigationStack independante, pour que la navigation dans un onglet
// ne perturbe pas les autres.
