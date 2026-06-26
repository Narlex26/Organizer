//
//  AjouterEvenementView.swift
//  Organizer 
//
//  OBJECTIF
//  --------
//  Formulaire de creation d'un evenement, avec validation metier
//  (BusinessLogic.swift) avant insertion en base.
//
//  CONCEPTS COUVERTS
//   - Form, Picker, DatePicker
//   - do / catch sur une fonction throws, Alert
//

import SwiftUI
import SwiftData

struct AjouterEvenementView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var nom = ""
    @State private var dateEvenement = Date.now.addingTimeInterval(7 * 24 * 3600)
    @State private var lieu = ""
    @State private var type: TypeEvenement = .autre
    @State private var budgetPrevuTexte = ""
    @State private var notes = ""

    @State private var erreur: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Evenement") {
                    TextField("Nom", text: $nom)
                    DatePicker("Date", selection: $dateEvenement, displayedComponents: .date)
                    Picker("Type", selection: $type) {
                        ForEach(TypeEvenement.allCases) { t in
                            Text(t.rawValue).tag(t)
                        }
                    }
                }
                Section("Lieu et budget") {
                    TextField("Lieu", text: $lieu)
                    TextField("Budget previsionnel (EUR)", text: $budgetPrevuTexte)
                        .keyboardType(.decimalPad)
                }
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                }
            }
            .navigationTitle("Nouvel evenement")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") { ajouter() }
                }
            }
            // TODO 8 (suite) : afficher une Alert quand `erreur` n'est pas
            //          nil, avec le message renvoye par validerEvenement.
        }
    }

    // TODO 8 (suite) : valider les champs via `validerEvenement` (Module A,
    //          BusinessLogic.swift) avant d'inserer l'evenement. En cas
    //          d'erreur (catch), stocker le message dans `erreur` au lieu
    //          d'inserer.
    private func ajouter() {
        // a implementer : insertion directe, sans validation pour l'instant
        let budget = Double(budgetPrevuTexte.replacingOccurrences(of: ",", with: ".")) ?? 0
        let nouvel = Evenement(nom: nom, dateEvenement: dateEvenement, lieu: lieu,
                                type: type, budgetPrevu: budget, notes: notes)
        context.insert(nouvel)
        dismiss()
    }
}

#Preview {
    AjouterEvenementView()
        .modelContainer(PreviewContainer.preview)
}
