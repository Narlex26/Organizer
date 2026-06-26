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
        // TODO 7 : assembler les 3 onglets (Evenements, Taches,
        //          Budget) dans une TabView, chacun dans son propre
        //          NavigationStack avec un tabItem (Label +
        //          systemImage adapte).
        NavigationStack {
            Text("a implementer")
                .navigationTitle("Organizer")
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
