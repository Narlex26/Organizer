//
//  BusinessLogic.swift
//  Organizer 
//
//  OBJECTIF
//  --------
//  Manipuler les entites SwiftData (Evenement, Tache, Depense...) avec
//  du Swift pur : protocoles, generiques, gestion d'erreurs,
//  agregations sur collections.
//
//  CONCEPTS COUVERTS
//   - Protocoles + extensions (programmation orientee protocole)
//   - Generiques avec closures
//   - Error / LocalizedError personnalise + throws
//   - filter / map / reduce / Dictionary(grouping:)
//
//  IMPORTANT : ce fichier n'importe ni SwiftUI ni SwiftData. Les types
//  Evenement, Tache, Depense... restent utilisables ici sans import
//  supplementaire car ils appartiennent au meme module (target Xcode)
//  -- "import" ne sert qu'a franchir une frontiere de framework, pas
//  une frontiere de fichier.
//

import Foundation

// MARK: - Protocole Recapitulable

// Un type "Recapitulable" sait produire un titre et un resume textuel
// d'une ligne. Deux entites tres differentes (un evenement, une
// tache) peuvent adopter ce contrat commun.
protocol Recapitulable {
    var titreRecap: String { get }
    func resume() -> String
}

// TODO 4 : faire conformer Evenement et Tache au protocole
//          Recapitulable (titreRecap, resume()). Pour Evenement, le
//          resume doit mentionner le nom, le type et la date/lieu.
//          Fais de meme pour Tache (titre / statut / priorite).
extension Evenement: Recapitulable {
    var titreRecap: String { "" } // a remplacer par `nom`
    func resume() -> String { "" } // a implementer
}

extension Tache: Recapitulable {
    var titreRecap: String { "" } // a remplacer par `titre`
    func resume() -> String { "" } // a implementer
}

// Fonction generique fournie : elle accepte n'importe quel tableau
// d'elements Recapitulable et produit un texte pret a etre copie.
func recapTexte<T: Recapitulable>(_ items: [T], titre: String) -> String {
    guard !items.isEmpty else { return "\(titre) : rien a signaler." }
    let lignes = items.map { "- \($0.resume())" }
    return "\(titre) :\n" + lignes.joined(separator: "\n")
}

// MARK: - Fonction generique de tri temporel

// TODO 5 : retourner les `limite` elements les plus recents d'un
//          tableau, quel que soit le type T, a condition de savoir
//          extraire une Date de chaque element via la closure
//          `dateDe`.
func elementsRecents<T>(_ items: [T], dateDe: (T) -> Date, limite: Int) -> [T] {
    Array(items.prefix(limite)) // a remplacer : pour l'instant aucun tri par date
}

// MARK: - Validation (gestion d'erreurs)

enum ErreurValidationEvenement: Error, LocalizedError {
    case nomVide
    case dateDansLePasse
    case budgetInvalide

    var errorDescription: String? {
        switch self {
        case .nomVide:
            "Le nom de l'evenement ne peut pas etre vide."
        case .dateDansLePasse:
            "La date de l'evenement doit etre dans le futur."
        case .budgetInvalide:
            "Le budget previsionnel doit etre strictement positif."
        }
    }
}

// TODO 6 : completer la fonction de validation ci-dessous ET les 3
//          agregations qui suivent (montantTotalDepenses,
//          tauxConfirmation, repartitionDepensesParCategorie).
//          Chacune ne fait que filtrer / transformer / reduire un
//          tableau -- aucune notion de SwiftData ici, uniquement du
//          Swift standard.
func validerEvenement(nom: String, date: Date, budgetPrevu: Double) throws {
    // a implementer : pour l'instant tout evenement est considere valide
}

func montantTotalDepenses(_ depenses: [Depense]) -> Double {
    0 // a implementer
}

func tauxConfirmation(_ invitations: [Invitation]) -> Double {
    0 // a implementer
}

func repartitionDepensesParCategorie(_ depenses: [Depense]) -> [CategorieDepense: Double] {
    [:] // a implementer
}

// IDEE A RETENIR
// --------------
// Une fois les objets en memoire, toute la logique (tri, filtre,
// agregation, validation) est du Swift standard : aucun appel a
// SwiftData ou SwiftUI n'est necessaire. C'est ce qui rend ces
// fonctions faciles a tester et reutilisables n'importe ou.
