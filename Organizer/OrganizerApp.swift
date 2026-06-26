//
//  OrganizerApp.swift
//  Organizer 
//
//  Point d'entree de l'application. Configure le ModelContainer SwiftData
//  et declenche l'amorcage des donnees de demonstration au premier lancement.
//

import SwiftUI
import SwiftData

@main
struct OrganizerApp: App {

    let container: ModelContainer = {
        let schema = Schema([
            Evenement.self,
            Contact.self,
            Invitation.self,
            Tache.self,
            Depense.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Impossible de creer le ModelContainer : \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    SeedData.amorcerSiNecessaire(context: container.mainContext)
                }
                .environment(\.locale, Locale(identifier: "fr_FR"))
                .tint(.indigo)
        }
        .modelContainer(container)
    }
}
