//
//  SeedData.swift
//  Organizer 
//
//  Donnees de demonstration : amorcage initial au premier lancement,
//  + conteneur en memoire dedie aux previews SwiftUI.
//

import Foundation
import SwiftData

enum SeedData {

    static func amorcerSiNecessaire(context: ModelContext) {
        let descripteur = FetchDescriptor<Evenement>()
        let dejaPresents = (try? context.fetch(descripteur).count) ?? 0
        guard dejaPresents == 0 else { return }
        peupler(context)
        try? context.save()
    }

    static func peupler(_ context: ModelContext) {
        let jour: TimeInterval = 24 * 3600

        // Contacts
        let claire = Contact(nom: "Claire Dubois", email: "claire.dubois@mail.fr", telephone: "06 11 22 33 44")
        let marc = Contact(nom: "Marc Lefevre", email: "marc.lefevre@mail.fr", telephone: "06 22 33 44 55")
        let julie = Contact(nom: "Julie Moreau", email: "julie.moreau@mail.fr", telephone: "06 33 44 55 66")
        let thomas = Contact(nom: "Thomas Bernard", email: "thomas.bernard@mail.fr", telephone: "06 44 55 66 77")
        let nina = Contact(nom: "Nina Costa", email: "nina.costa@mail.fr", telephone: "06 55 66 77 88")
        let hugo = Contact(nom: "Hugo Petit", email: "hugo.petit@mail.fr", telephone: "06 66 77 88 99")
        for c in [claire, marc, julie, thomas, nina, hugo] {
            context.insert(c)
        }

        // Evenement 1 : Mariage, dans 60 jours
        let mariage = Evenement(nom: "Mariage Claire & Marc",
                                 dateEvenement: .now.addingTimeInterval(60 * jour),
                                 lieu: "Chateau de Valliere",
                                 type: .mariage,
                                 budgetPrevu: 15000,
                                 notes: "Ceremonie a 15h, vin d'honneur dans le parc si beau temps.")
        context.insert(mariage)

        context.insert(Invitation(statut: .confirme, plusUn: true, tableNumero: 1, evenement: mariage, contact: claire))
        context.insert(Invitation(statut: .confirme, plusUn: true, tableNumero: 1, evenement: mariage, contact: marc))
        context.insert(Invitation(statut: .confirme, plusUn: false, tableNumero: 2, evenement: mariage, contact: julie))
        context.insert(Invitation(statut: .enAttente, plusUn: true, tableNumero: nil, evenement: mariage, contact: thomas))
        context.insert(Invitation(statut: .decline, plusUn: false, tableNumero: nil, evenement: mariage, contact: hugo))

        context.insert(Tache(titre: "Reserver le traiteur", dateLimite: .now.addingTimeInterval(-5 * jour),
                              statut: .terminee, priorite: .haute, evenement: mariage, assigneA: claire))
        context.insert(Tache(titre: "Envoyer les faire-part", dateLimite: .now.addingTimeInterval(-2 * jour),
                              statut: .aFaire, priorite: .haute, evenement: mariage, assigneA: marc))
        context.insert(Tache(titre: "Choisir le plan de table", dateLimite: .now.addingTimeInterval(20 * jour),
                              statut: .enCours, priorite: .normale, evenement: mariage, assigneA: claire))
        context.insert(Tache(titre: "Essayage final robe", dateLimite: .now.addingTimeInterval(40 * jour),
                              statut: .aFaire, priorite: .basse, evenement: mariage, assigneA: claire))

        context.insert(Depense(libelle: "Acompte traiteur", montant: 2000, categorie: .restauration,
                                date: .now.addingTimeInterval(-10 * jour), evenement: mariage))
        context.insert(Depense(libelle: "Acompte salle", montant: 1500, categorie: .location,
                                date: .now.addingTimeInterval(-8 * jour), evenement: mariage))
        context.insert(Depense(libelle: "Fleurs ceremonie", montant: 450, categorie: .decoration,
                                date: .now.addingTimeInterval(-3 * jour), evenement: mariage))

        // Evenement 2 : Anniversaire, dans 18 jours
        let anniversaire = Evenement(nom: "Anniversaire 30 ans de Nina",
                                      dateEvenement: .now.addingTimeInterval(18 * jour),
                                      lieu: "Le Loft Bellevue",
                                      type: .anniversaire,
                                      budgetPrevu: 2500,
                                      notes: "Surprise -- ne rien dire a Nina avant le jour J.")
        context.insert(anniversaire)

        context.insert(Invitation(statut: .confirme, plusUn: false, tableNumero: nil, evenement: anniversaire, contact: julie))
        context.insert(Invitation(statut: .confirme, plusUn: true, tableNumero: nil, evenement: anniversaire, contact: thomas))
        context.insert(Invitation(statut: .enAttente, plusUn: false, tableNumero: nil, evenement: anniversaire, contact: hugo))

        context.insert(Tache(titre: "Reserver le loft", dateLimite: .now.addingTimeInterval(-6 * jour),
                              statut: .terminee, priorite: .haute, evenement: anniversaire, assigneA: julie))
        context.insert(Tache(titre: "Commander le gateau", dateLimite: .now.addingTimeInterval(-1 * jour),
                              statut: .aFaire, priorite: .haute, evenement: anniversaire, assigneA: thomas))
        context.insert(Tache(titre: "Preparer la playlist", dateLimite: .now.addingTimeInterval(10 * jour),
                              statut: .enCours, priorite: .normale, evenement: anniversaire, assigneA: nil))

        context.insert(Depense(libelle: "Acompte loft", montant: 300, categorie: .location,
                                date: .now.addingTimeInterval(-6 * jour), evenement: anniversaire))
        context.insert(Depense(libelle: "Ballons et banderoles", montant: 80, categorie: .decoration,
                                date: .now.addingTimeInterval(-2 * jour), evenement: anniversaire))

        // Evenement 3 : Conference, dans 10 jours
        let conference = Evenement(nom: "Conference DevTech 2026",
                                    dateEvenement: .now.addingTimeInterval(10 * jour),
                                    lieu: "Centre des Congres",
                                    type: .conference,
                                    budgetPrevu: 8000,
                                    notes: "200 participants attendus, prevoir badges et signaletique.")
        context.insert(conference)

        context.insert(Invitation(statut: .confirme, plusUn: false, tableNumero: nil, evenement: conference, contact: nina))
        context.insert(Invitation(statut: .confirme, plusUn: false, tableNumero: nil, evenement: conference, contact: hugo))

        context.insert(Tache(titre: "Valider la liste des intervenants", dateLimite: .now.addingTimeInterval(-3 * jour),
                              statut: .terminee, priorite: .haute, evenement: conference, assigneA: nina))
        context.insert(Tache(titre: "Imprimer les badges", dateLimite: .now.addingTimeInterval(5 * jour),
                              statut: .aFaire, priorite: .normale, evenement: conference, assigneA: hugo))

        context.insert(Depense(libelle: "Location salle plenaire", montant: 4000, categorie: .location,
                                date: .now.addingTimeInterval(-20 * jour), evenement: conference))
        context.insert(Depense(libelle: "Transport materiel audiovisuel", montant: 350, categorie: .transport,
                                date: .now.addingTimeInterval(-4 * jour), evenement: conference))
    }
}

// MARK: - Conteneur pour les previews SwiftUI

enum PreviewContainer {
    @MainActor
    static var preview: ModelContainer = {
        let schema = Schema([
            Evenement.self, Contact.self, Invitation.self, Tache.self, Depense.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [config])
        SeedData.peupler(container.mainContext)
        return container
    }()

    @MainActor
    static var exampleEvenement: Evenement {
        let descripteur = FetchDescriptor<Evenement>(sortBy: [SortDescriptor(\.dateEvenement)])
        let result = try? preview.mainContext.fetch(descripteur)
        return result?.first ?? Evenement(nom: "Test", lieu: "—", type: .autre, budgetPrevu: 1000)
    }
}
