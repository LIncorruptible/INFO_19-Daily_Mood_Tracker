//
//  LoginView.swift
//  DailyMoodTracker
//
//  Created by etudiant on 29/12/2024.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.modelContext) private var context
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoginSuccessful = false
    @State private var navigateToDashboard = false // État pour gérer la redirection

    private let loginController = LoginController()
    @ObservedObject private var userSession = UserSession.shared // Utilisation de la session utilisateur

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Connexion")) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("Mot de passe", text: $password)
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button("Se connecter") {
                    handleLogin()
                }
                .disabled(email.isEmpty || password.isEmpty)

                Section {
                    NavigationLink("Créer un compte", destination: SignUpView())
                        .foregroundColor(.blue)
                }
            }
            .navigationTitle("Connexion")
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigateToDashboard) {
                DashboardView() // Redirection vers DashboardView
            }
            .alert("Succès", isPresented: $isLoginSuccessful) {
                Button("OK") {
                    navigateToDashboard = true // Déclenche la redirection après confirmation
                }
            } message: {
                Text("Connexion réussie !")
            }
        }
    }

    private func handleLogin() {
        do {
            let user = try loginController.login(
                email: email,
                password: password,
                context: context
            )
            userSession.login(user: user) // Stocker l'utilisateur dans la session
            isLoginSuccessful = true
            clearFields()
        } catch let error as LoginError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Une erreur inattendue s'est produite."
        }
    }

    private func clearFields() {
        email = ""
        password = ""
    }
}
