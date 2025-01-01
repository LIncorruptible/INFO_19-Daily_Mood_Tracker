//
//  SignUpController.swift
//  DailyMoodTracker
//
//  Created by etudiant on 29/12/2024.
//


import Foundation
import SwiftData

class SignUpController : UserController {
    
    // MARK: - Constructeur
    override init(context: ModelContext) {
        super.init(context: context)
    }
    
    // MARK: - signUp
    // Fonction pour inscrire un nouvel utilisateur
    func signUp(username: String, email: String, password: String, confirmPassword: String) throws {
        // Validation des champs
        guard !username.isEmpty else { throw SignUpError.emptyUsername }
        guard email.isValidEmail else { throw SignUpError.invalidEmail }
        guard password == confirmPassword else { throw SignUpError.passwordMismatch }
        guard password.isStrongPassword else { throw SignUpError.weakPassword }

        // Vérifier si l'email existe déjà
        let fetchDescriptor = FetchDescriptor<User>(predicate: #Predicate { $0.email == email })
        let existingUsers = try context.fetch(fetchDescriptor)

        guard existingUsers.isEmpty else { throw SignUpError.emailAlreadyExists }

        // Création du nouvel utilisateur
        let hashedPassword = password.hash() // Hachage du mot de passe
        let newUser = User(id: UUID(), username: username, email: email, password: hashedPassword)
        
        // Enregistrement
        try create(user: newUser)
    }
}

// MARK: - SignUpError
// Enum pour les erreurs d'inscription
enum SignUpError: Error, LocalizedError {
    case emptyUsername
    case invalidEmail
    case passwordMismatch
    case weakPassword
    case emailAlreadyExists

    var errorDescription: String? {
        switch self {
        case .emptyUsername: return "Le nom d'utilisateur est requis."
        case .invalidEmail: return "L'adresse email n'est pas valide."
        case .passwordMismatch: return "Les mots de passe ne correspondent pas."
        case .weakPassword: return "Le mot de passe est trop faible."
        case .emailAlreadyExists: return "Un compte avec cet email existe déjà."
        }
    }
}

// MARK: - Extensions
// Extensions pour les validations
extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }

    var isStrongPassword: Bool {
        // Minimum 8 caractères, au moins 1 majuscule, 1 minuscule, 1 chiffre
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d$@$!%*?&]{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }

    func hash() -> String {
        // Exemple de hachage SHA256
        guard let data = self.data(using: .utf8) else { return self }
        let hashed = data.map { String(format: "%02hhx", $0) }.joined()
        return hashed
    }
}
