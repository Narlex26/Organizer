//
//  Models.swift
//  Organizer 
//
//  OBJECTIF
//  --------
//  Modeliser les 5 entites de l'app (Evenement, Contact, Invitation,
//  Tache, Depense) avec leurs relations SwiftData : 1-N classique, et
//  une N-N enrichie (Invitation, entre Evenement et Contact).
//
//  CONCEPTS COUVERTS
//   - @Model, @Relationship, deleteRule (.cascade / .nullify)
//   - Entite d'association pour une relation N-N enrichie
//   - enum avec switch (Module A2 / A6)
//

import Foundation
import SwiftData
import SwiftUI

// MARK: - Enums metier

enum TypeEvenement: String, Codable, CaseIterable, Identifiable {
    case mariage    = "Mariage"
    case anniversaire = "Anniversaire"
    case conference = "Conference"
    case soiree     = "Soiree"
    case autre      = "Autre"

    var id: String { rawValue }

    var symbole: String {
        switch self {
        case .mariage:      "heart.fill"
        case .anniversaire: "birthday.cake.fill"
        case .conference:   "person.3.fill"
        case .soiree:       "music.note"
        case .autre:        "calendar"
        }
    }
}

enum StatutRSVP: String, Codable, CaseIterable, Identifiable {
    case enAttente = "En attente"
    case confirme  = "Confirme"
    case decline   = "Decline"

    var id: String { rawValue }

    var couleur: Color {
        switch self {
        case .enAttente: .orange
        case .confirme:  .green
        case .decline:   .red
        }
    }
}

enum StatutTache: String, Codable, CaseIterable, Identifiable {
    case aFaire   = "A faire"
    case enCours  = "En cours"
    case terminee = "Terminee"

    var id: String { rawValue }

    // Fait cycler le statut vers l'etape suivante :
    // A faire -> En cours -> Terminee -> A faire.
    // Utilise par le swipe action de TachesView et EvenementDetailView.
    var suivant: StatutTache {
        switch self {
        case .aFaire:   .enCours
        case .enCours:  .terminee
        case .terminee: .aFaire
        }
    }

    var couleur: Color {
        switch self {
        case .aFaire:   .secondary
        case .enCours:  .blue
        case .terminee: .green
        }
    }

    var symbole: String {
        switch self {
        case .aFaire:   "circle"
        case .enCours:  "circle.lefthalf.filled"
        case .terminee: "checkmark.circle.fill"
        }
    }
}

enum PrioriteTache: String, Codable, CaseIterable, Identifiable {
    case basse   = "Basse"
    case normale = "Normale"
    case haute   = "Haute"

    var id: String { rawValue }

    var couleur: Color {
        switch self {
        case .basse:   .gray
        case .normale: .blue
        case .haute:   .red
        }
    }
}

enum CategorieDepense: String, Codable, CaseIterable, Identifiable {
    case location     = "Location"
    case restauration = "Restauration"
    case decoration   = "Decoration"
    case transport    = "Transport"
    case divers       = "Divers"

    var id: String { rawValue }
}

// MARK: - Evenement (entite racine)

@Model
final class Evenement {
    var nom: String
    var dateEvenement: Date
    var lieu: String
    var type: TypeEvenement
    var budgetPrevu: Double
    var notes: String

    // Relations 1-N depuis Evenement, en cascade : supprimer un
    // evenement supprime ses invitations, taches et depenses, qui
    // n'ont aucun sens sans lui. L'inverse pointe vers la propriete
    // `evenement` portee par chaque entite enfant.
    @Relationship(deleteRule: .cascade, inverse: \Invitation.evenement)
    var invitations: [Invitation] = []

    @Relationship(deleteRule: .cascade, inverse: \Tache.evenement)
    var taches: [Tache] = []

    @Relationship(deleteRule: .cascade, inverse: \Depense.evenement)
    var depenses: [Depense] = []

    init(nom: String,
         dateEvenement: Date = .now,
         lieu: String,
         type: TypeEvenement,
         budgetPrevu: Double,
         notes: String = "")
    {
        self.nom = nom
        self.dateEvenement = dateEvenement
        self.lieu = lieu
        self.type = type
        self.budgetPrevu = budgetPrevu
        self.notes = notes
    }
}

// MARK: - Contact (reutilisable entre evenements)

@Model
final class Contact {
    var nom: String
    var email: String
    var telephone: String

    // Cote "reutilisable" : supprimer un contact met Contact a nil
    // sur ses Invitation (nullify) pour preserver l'historique RSVP.
    @Relationship(deleteRule: .nullify, inverse: \Invitation.contact)
    var invitations: [Invitation] = []

    init(nom: String, email: String = "", telephone: String = "") {
        self.nom = nom
        self.email = email
        self.telephone = telephone
    }

    var initiales: String {
        let mots = nom.split(separator: " ")
        let lettres = mots.compactMap { $0.first }.map(String.init)
        return lettres.joined().uppercased()
    }
}

// MARK: - Invitation (relation N-N enrichie Evenement <-> Contact)

@Model
final class Invitation {
    var statut: StatutRSVP
    var plusUn: Bool
    var tableNumero: Int?

    var evenement: Evenement?
    var contact: Contact?

    init(statut: StatutRSVP = .enAttente,
         plusUn: Bool = false,
         tableNumero: Int? = nil,
         evenement: Evenement? = nil,
         contact: Contact? = nil)
    {
        self.statut = statut
        self.plusUn = plusUn
        self.tableNumero = tableNumero
        self.evenement = evenement
        self.contact = contact
    }
}

// MARK: - Tache (1-N depuis Evenement, assignable a un Contact)

@Model
final class Tache {
    var titre: String
    var dateLimite: Date
    var statut: StatutTache
    var priorite: PrioriteTache

    var evenement: Evenement?
    var assigneA: Contact?

    init(titre: String,
         dateLimite: Date,
         statut: StatutTache = .aFaire,
         priorite: PrioriteTache = .normale,
         evenement: Evenement? = nil,
         assigneA: Contact? = nil)
    {
        self.titre = titre
        self.dateLimite = dateLimite
        self.statut = statut
        self.priorite = priorite
        self.evenement = evenement
        self.assigneA = assigneA
    }

    var enRetard: Bool {
        statut != .terminee && dateLimite < .now
    }
}

// MARK: - Depense (1-N depuis Evenement)

@Model
final class Depense {
    var libelle: String
    var montant: Double
    var categorie: CategorieDepense
    var date: Date

    var evenement: Evenement?

    init(libelle: String,
         montant: Double,
         categorie: CategorieDepense,
         date: Date = .now,
         evenement: Evenement? = nil)
    {
        self.libelle = libelle
        self.montant = montant
        self.categorie = categorie
        self.date = date
        self.evenement = evenement
    }
}

// IDEE A RETENIR
// --------------
// Cote "racine" d'une relation (Evenement), on declare @Relationship
// avec deleteRule + inverse. Cote "reutilisable" (Contact), on fait
// pareil mais avec .nullify pour preserver l'historique. L'entite
// d'association (Invitation) ne porte elle-meme aucune macro : juste
// deux proprietes optionnelles simples vers ses deux parents.
