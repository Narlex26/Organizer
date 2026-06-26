# TP final — Organizer, une app de gestion d'événements

> Évaluation de fin de formation : Module A (Swift), Module B (SwiftUI), Module C (SwiftData)
> Durée  : 4 heures

---

## 1. Présentation

`Organizer` est une application de gestion d'événements (mariages, anniversaires, conférences, soirées). Un·e utilisateur·rice y crée des événements, invite des contacts, suit des tâches d'organisation et tient le budget.

Ce TP est l'évaluation finale du cours. Il mobilise, dans une seule application cohérente, les trois piliers vus depuis le début de la formation.

- **Module A (Swift)** : protocoles, generics, closures, gestion d'erreurs (`throws`), collections (`filter`/`map`/`reduce`, `Dictionary(grouping:)`) — dans un fichier **sans aucune dépendance à SwiftUI ou SwiftData**.
- **Module B (SwiftUI)** : `TabView`, `NavigationStack`, `Form`, `@Bindable`, `swipeActions`, animations.
- **Module C (SwiftData)** (cf. `DiveLog` et `Cours_SwiftData.md`) : `@Model`,`@Query`, relations 1-N et N-N enrichie, `deleteRule`, `@Query`.

Le principe pédagogique : une fois les objets persistés en mémoire (peu importe via SwiftData), les manipuler (trier, filtrer, agréger, valider) redevient du Swift pur. C'est ce que vous allez constater concrètement dans `BusinessLogic.swift`.

---

## 2. Modèle de données

5 entités, organisées autour de l'événement :

| Entité | Rôle | Relation |
|---|---|---|
| `Evenement` | L'événement organisé | Racine — 1-N vers les 3 entités suivantes |
| `Contact` | Personne invitable, réutilisable entre événements | N-N enrichie avec `Evenement` via `Invitation` |
| `Invitation` | Le lien RSVP entre un contact et un événement | Entité d'association (statut, plus-un, table) |
| `Tache` | Tâche d'organisation | 1-N depuis `Evenement`, assignable à un `Contact` |
| `Depense` | Ligne de budget | 1-N depuis `Evenement` |

### Pourquoi une entité d'association ?

`Contact` est **réutilisable** d'un événement à l'autre (le même contact peut être invité à plusieurs événements). Le statut RSVP n'appartient ni au contact seul ni à l'événement seul : il appartient à la **rencontre** entre les deux. C'est le pattern N-N enrichie vu sur `UsageEquipement` dans `DiveLog` (voir `Cours_SwiftData.md`, partie 2).

### Règles de suppression attendues

- Supprimer un `Evenement` supprime en cascade ses `Invitation`, `Tache`, `Depense` : ces objets n'ont aucun sens sans l'événement.
- Supprimer un `Contact` ne doit **pas** supprimer l'historique (`Invitation` associées) : elles deviennent orphelines (`nullify`), pour préserver la trace.

---

## 3. Travail à réaliser

Le TP est réparti en 4 parties, 11 `TODO` au total. Le projet `Organizer/` contient déjà la structure et l'UI de base ; chaque `TODO` numéroté indique un point précis à compléter.

### Partie 1 — Modélisation SwiftData (`Models.swift`)

1. Compléter les `@Relationship` de `Evenement` vers `Invitation`, `Tache`, `Depense` (cascade + inverse).
2. Compléter la relation N-N enrichie `Contact` ↔ `Evenement` via `Invitation` (côté `Contact`, `deleteRule: .nullify`).
3. Implémenter `StatutTache.suivant`, qui fait cycler une tâche `À faire → En cours → Terminée → À faire` (pattern matching `switch`).

### Partie 2 — Logique métier en Swift pur (`BusinessLogic.swift`)

Ce fichier **n'importe ni `SwiftUI` ni `SwiftData`** (uniquement `Foundation`). Il prouve que manipuler des objets déjà chargés en mémoire est indépendant du framework de persistance.

4. Déclarer le protocole `Recapitulable` (`titreRecap: String`, `func resume() -> String`) et le faire adopter par `Evenement` et `Tache` via des extensions.
5. Écrire la fonction générique `elementsRecents<T>(_:dateDe:limite:)` qui retourne les `limite` éléments les plus récents d'un tableau `[T]`, quel que soit `T` (closures, generics).
6. Définir l'erreur `ErreurValidationEvenement` (`Error`, `LocalizedError`) et la fonction `throws` `validerEvenement(nom:date:budgetPrevu:)`, puis les 3 fonctions d'agrégation : `montantTotalDepenses`, `tauxConfirmation`, `repartitionDepensesParCategorie` (cette dernière retourne un `[CategorieDepense: Double]` via `Dictionary(grouping:)`).

### Partie 3 — SwiftUI

7. `ContentView` : assembler le `TabView` à 3 onglets (Évènements, Tâches, Budget), chacun dans son `NavigationStack`.
8. `EvenementsView` / `AjouterEvenementView` : liste triée par date (`@Query`), formulaire d'ajout qui appelle `validerEvenement` et affiche une `Alert` en cas d'erreur.
9. `EvenementDetailView` : résumé budget (`ProgressView` budget engagé vs prévu, animé), section Invités (statut RSVP modifiable via `Picker` + `@Bindable`), section Tâches (swipe pour faire avancer le statut via `StatutTache.suivant`, avec animation).
10. `BudgetView` : un graphique `Charts` (`BarMark`) de répartition des dépenses par catégorie, construit à partir de `repartitionDepensesParCategorie`.

### Partie 4 — Intégration

11. Dans `EvenementDetailView`, un bouton "Copier le récapitulatif" qui appelle `elementsRecents` + `recapTexte` sur les `Tache` de l'événement et place le texte dans le presse-papiers (`UIPasteboard`) — la preuve que Module A, B et SwiftData coopèrent dans une seule action utilisateur.

---

## 4. Lancer le projet

1. Xcode 26 → nouveau projet `App` (template iOS, interface SwiftUI, Swift 6).
2. Supprimer les fichiers `<Nom>App.swift` et `ContentView.swift` générés par défaut.
3. Glisser tous les `.swift` de `Organizer/` dans le navigateur de projet (*Copy items if needed*).
4. Cible iOS 17.0 minimum.
5. Compiler et lancer sur simulateur. Au premier lancement, l'app insère 3 événements, 6 contacts et leurs tâches/dépenses associées.

---

## 5. Critères d'évaluation

| Partie | Points | Attendu |
|---|---|---|
| Modélisation SwiftData | 5 | Relations correctes, `deleteRule` justifiées, schéma enregistré |
| Logique Swift pure | 6 | Protocole + generics + `throws` + agrégations fonctionnels et réellement indépendants de SwiftUI/SwiftData |
| SwiftUI | 6 | Navigation, formulaire fonctionnel, `@Bindable`, animation visible, `Charts` correct |
| Intégration | 2 | Le bouton récap mobilise bien les trois modules |
| Qualité générale | 1 | Code qui compile, nommage cohérent, pas de force-unwrap hasardeux |

**Total : 20 points.**

---

## 6. Fichiers du projet (12)

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
