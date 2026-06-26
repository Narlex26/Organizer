//
//  AjouterInviteView.swift
//  Organizer 
//

import SwiftUI
import SwiftData

struct AjouterInviteView: View {
    let evenement: Evenement

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Contact.nom) private var contacts: [Contact]

    @State private var contactSelectionne: Contact?
    @State private var nouveauNom = ""
    @State private var plusUn = false
    @State private var tableTexte = ""

    private var dejaInvites: Set<PersistentIdentifier> {
        Set(evenement.invitations.compactMap { $0.contact?.persistentModelID })
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Contact existant") {
                    if contacts.isEmpty {
                        Text("Aucun contact enregistre.").foregroundStyle(.secondary)
                    } else {
                        Picker("Contact", selection: $contactSelectionne) {
                            Text("Aucun").tag(Contact?.none)
                            ForEach(contacts) { contact in
                                Text(contact.nom)
                                    .tag(Optional(contact))
                                    .disabled(dejaInvites.contains(contact.persistentModelID))
                            }
                        }
                    }
                }
                Section("Ou nouveau contact") {
                    TextField("Nom complet", text: $nouveauNom)
                }
                Section("Details") {
                    Toggle("Avec accompagnant (+1)", isOn: $plusUn)
                    TextField("Numero de table (optionnel)", text: $tableTexte)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Inviter")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Inviter") { inviter() }
                        .disabled(contactSelectionne == nil && nouveauNom.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func inviter() {
        let contact: Contact
        if let selection = contactSelectionne {
            contact = selection
        } else {
            let nouveau = Contact(nom: nouveauNom)
            context.insert(nouveau)
            contact = nouveau
        }
        let invitation = Invitation(plusUn: plusUn, tableNumero: Int(tableTexte),
                                     evenement: evenement, contact: contact)
        context.insert(invitation)
        dismiss()
    }
}

#Preview {
    AjouterInviteView(evenement: PreviewContainer.exampleEvenement)
        .modelContainer(PreviewContainer.preview)
}
