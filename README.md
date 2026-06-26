# Organizer — TP final (4h) 

App SwiftUI / SwiftData (iOS 17+, Swift 6) de gestion d'événements (mariages, anniversaires, conférences...).
**Version de base** à compléter via les 11 exercices numérotés (`TODO 1` à `TODO 11`).

> Sujet complet et critères d'évaluation : voir `Sujet_Organizer.md`.

## Comment lancer

1. Dans Xcode 26, créer un projet `App` (template iOS, interface SwiftUI, Swift 6).
2. Supprimer les fichiers `<Nom>App.swift` et `ContentView.swift` générés par défaut.
3. Glisser-déposer tous les fichiers `.swift` de ce dossier dans le navigateur de projet (cocher *Copy items if needed*).
4. Cible **iOS 17.0 minimum**.
5. Compiler et lancer sur simulateur. Le projet compile dès le départ : chaque `TODO` est remplacé par une valeur ou un texte provisoire qui n'empêche pas la compilation.

Au premier lancement, l'app insère 3 événements, 6 contacts et leurs tâches/dépenses associées.

## Où sont les exercices

| TODO | Fichier | Sujet |
|---|---|---|
| 1-3 | `Models.swift` | Relations `@Relationship` (cascade/nullify) + `StatutTache.suivant` |
| 4-6 | `BusinessLogic.swift` | Protocole `Recapitulable`, générique `elementsRecents`, erreur `throws`, agrégations |
| 7 | `ContentView.swift` | Assemblage du `TabView` |
| 8 | `EvenementsView.swift` / `AjouterEvenementView.swift` | `@Query(sort:)`, validation + `Alert` |
| 9 | `EvenementDetailView.swift` | `ProgressView` animée, `Picker`+`@Bindable`, `swipeActions`+animation |
| 10 | `BudgetView.swift` | Graphique `Charts` (`BarMark`) |
| 11 | `EvenementDetailView.swift` | Bouton "Copier le récapitulatif" (Module A + B + SwiftData) |

Les 5 autres fichiers (`SeedData.swift`, `OrganizerApp.swift`, `AjouterInviteView.swift`, `TachesView.swift`, `AjouterTacheView.swift`) sont fournis complets : ils servent de support et de modèle pour les parties à compléter.

## Fichiers (12)

| Fichier | Rôle |
|---|---|
| `OrganizerApp.swift` | Entrée App + `ModelContainer` + locale FR |
| `Models.swift` | 5 `@Model` + enums métier |
| `BusinessLogic.swift` | Logique Swift pure (protocole, generics, throws, agrégations) |
| `SeedData.swift` | Données de démo + `PreviewContainer` |
| `ContentView.swift` | `TabView` racine (3 onglets) |
| `EvenementsView.swift` | Liste des événements |
| `AjouterEvenementView.swift` | Formulaire d'ajout + validation |
| `EvenementDetailView.swift` | Fiche complète (invités, tâches, budget, récap) |
| `AjouterInviteView.swift` | Invitation d'un contact existant ou nouveau |
| `TachesView.swift` | Toutes les tâches, groupées par statut |
| `AjouterTacheView.swift` | Formulaire d'ajout de tâche |
| `BudgetView.swift` | Graphique de répartition des dépenses |
