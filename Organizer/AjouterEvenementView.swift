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
            .alert("Erreur de validation", isPresented: Binding(
                get: { erreur != nil },
                set: { _ in erreur = nil }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                if let erreur { Text(erreur) }
            }
        }
    }

    private func ajouter() {
        let budget = Double(budgetPrevuTexte.replacingOccurrences(of: ",", with: ".")) ?? 0
        do {
            try validerEvenement(nom: nom, date: dateEvenement, budgetPrevu: budget)
            let nouvel = Evenement(nom: nom, dateEvenement: dateEvenement, lieu: lieu,
                                    type: type, budgetPrevu: budget, notes: notes)
            context.insert(nouvel)
            dismiss()
        } catch {
            erreur = error.localizedDescription
        }
    }
}

#Preview {
    AjouterEvenementView()
        .modelContainer(PreviewContainer.preview)
}
