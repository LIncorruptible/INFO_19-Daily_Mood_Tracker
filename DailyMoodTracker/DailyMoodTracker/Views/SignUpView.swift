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
    @State private var isSignUpSuccessful = false

    private let signUpController = SignUpController()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Créer un compte")) {
                    TextField("Nom d'utilisateur", text: $username)
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
            .alert("Succès", isPresented: $isSignUpSuccessful) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Inscription réussie ! Vous pouvez maintenant vous connecter.")
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
            isSignUpSuccessful = true
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
