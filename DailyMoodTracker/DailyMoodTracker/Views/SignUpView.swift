//
//  SignUpView.swift
//  DailyMoodTracker
//
//  Created by etudiant on 29/12/2024.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.modelContext) private var context
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @State private var showSuccessAlert = false // Nouveau état pour afficher l'alerte
    @State private var navigateToLogin = false // Gère la navigation vers LoginView

    private let signUpController = SignUpController()

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Créer un compte")) {
                    TextField("Nom d'utilisateur", text: $username)
                        .autocapitalization(.none)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("Mot de passe", text: $password)
                    SecureField("Confirmer le mot de passe", text: $confirmPassword)
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button("S'inscrire") {
                    handleSignUp()
                }
                .disabled(username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            }
            .navigationTitle("Inscription")
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView() // Redirige vers LoginView
            }
            .alert("Succès", isPresented: $showSuccessAlert) { // Configuration de l'alerte
                Button("OK") {
                    navigateToLogin = true // Redirige vers LoginView après la confirmation
                }
            } message: {
                Text("Votre compte a été créé avec succès.")
            }
        }
    }

    private func handleSignUp() {
        do {
            try signUpController.signUp(
                username: username,
                email: email,
                password: password,
                confirmPassword: confirmPassword,
                context: context
            )
            showSuccessAlert = true // Affiche l'alerte de succès
            clearFields()
        } catch let error as SignUpError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Une erreur inattendue s'est produite."
        }
    }

    private func clearFields() {
        username = ""
        email = ""
        password = ""
        confirmPassword = ""
    }
}
