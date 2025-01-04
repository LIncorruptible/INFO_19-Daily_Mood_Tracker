//
//  AccountView.swift
//  DailyMoodTracker
//
//  Created by etudiant on 04/01/2025.
//

import SwiftUI
import SwiftData

struct AccountView: View {
    @State private var isEditingInfo: Bool = false
    
    @ObservedObject private var userSession = UserSession.shared
    @Environment(\.modelContext) private var context: ModelContext
    
    @State private var user: User
    
    init(localUser: User) {
        _user = State(initialValue: localUser)
    }

    var body: some View {
        Form {
            // Section des informations du compte
            Section(header: Text("COMPTE")) {
                NavigationLink(destination: EditAccountView(user: $user)) {
                    HStack {
                        Text("Nom d'utilisateur")
                        Spacer()
                        Text(user.username)
                            .foregroundColor(.secondary)
                    }
                }
                
                NavigationLink(destination: EditAccountView(user: $user)) {
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(user.email)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Section pour se déconnecter
            Section {
                Button(role: .destructive) {
                    logout()
                } label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Se déconnecter")
                    }
                }
            }
        }
        .navigationBarTitle("Mon compte", displayMode: .inline)
    }
    
    // MARK: - Déconnexion
    private func logout() {
        print("Déconnexion effectuée")
        // Implémentez la logique de déconnexion ici
    }
}

struct EditAccountView: View {
    @Binding var user: User // Lien vers l'utilisateur depuis la vue parent
    @Environment(\.dismiss) private var dismiss // Pour fermer la vue
    
    @Environment(\.modelContext) private var context: ModelContext
    
    @State private var username: String
    @State private var email: String
    
    @State private var isSaving = false
    @State private var errorMessage: String?
    @State private var showSuccessAlert = false // Nouveau état pour afficher l'alerte

    init(user: Binding<User>) {
        _user = user
        _username = State(initialValue: user.wrappedValue.username)
        _email = State(initialValue: user.wrappedValue.email)
    }

    var body: some View {
        Form {
            Section(header: Text("Nom d'utilisateur").font(.headline)) {
                TextField("Entrez votre nom d'utilisateur", text: $username)
            }
            Section(header: Text("Email").font(.headline)) {
                TextField("Entrez votre email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }

            if let errorMessage = errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
        }
        .navigationBarTitle("Modifier le compte", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Annuler") { dismiss() }
                    .foregroundColor(.red)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Enregistrer") { handleEditAccount() }
                    .bold()
                    .disabled(isSaving)
                    .alert("Succès", isPresented: $showSuccessAlert) { // Configuration de l'alerte
                        Button("OK") {
                            dismiss() // Ferme la vue après la confirmation
                        }
                    } message: {
                        Text("Votre compte a été modifié avec succès.")
                    }
            }
        }
    }

    private func handleEditAccount() {
        let signUpController = SignUpController(context: context)
        do {
            try signUpController.editAccount(user: user, newUsername: username, newEmail: email)
            showSuccessAlert = true // Affiche l'alerte de succès
            clearFields()
        } catch let error {
            errorMessage = error.localizedDescription
        }
    }

    private func clearFields() {
        username = ""
        email = ""
    }
}

// MARK: - ValidationError
struct ValidationError: LocalizedError {
    private var message: String
    init(_ message: String) {
        self.message = message
    }

    var errorDescription: String? {
        return message
    }
}
