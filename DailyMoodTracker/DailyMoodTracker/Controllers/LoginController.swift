//
//  LoginController.swift
//  DailyMoodTracker
//
//  Created by etudiant on 29/12/2024.
//


import Foundation
import SwiftData

class LoginController {
    func login(email: String, password: String, context: ModelContext) throws -> User {
        // Validation des champs
        guard email.isValidEmail else { throw LoginError.invalidEmail }
        guard !password.isEmpty else { throw LoginError.emptyPassword }

        // Vérifier si l'utilisateur existe
        let fetchDescriptor = FetchDescriptor<User>(predicate: #Predicate { $0.email == email })
        let users = try context.fetch(fetchDescriptor)

        guard let user = users.first else {
            throw LoginError.userNotFound
        }

        // Vérification du mot de passe
        let hashedPassword = password.hash()
        guard user.password == hashedPassword else {
            throw LoginError.incorrectPassword
        }

        return user // Retourne l'utilisateur connecté
    }
}

// Enum pour les erreurs de connexion
enum LoginError: Error, LocalizedError {
    case invalidEmail
    case emptyPassword
    case userNotFound
    case incorrectPassword

    var errorDescription: String? {
        switch self {
        case .invalidEmail: return "L'adresse email n'est pas valide."
        case .emptyPassword: return "Le mot de passe est requis."
        case .userNotFound: return "Aucun utilisateur trouvé avec cet email."
        case .incorrectPassword: return "Mot de passe incorrect."
        }
    }
}