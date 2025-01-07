//
//  SignUpController.swift
//  DailyMoodTracker
//
//  Created by etudiant on 29/12/2024.
//

import Foundation
import SwiftData

// MARK: - SignUpController
// Classe pour la gestion de l'inscription et la modification de compte
// Hérite de UserController
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
    
    // MARK: - editAccount
    // Fonction pour modifier un compte existant
    func editAccount(user: User, newUsername: String, newEmail: String) throws {
        // Validation des champs
        guard !newUsername.isEmpty else { throw EditAccountError.emptyUsername }
        guard newEmail.isValidEmail else { throw EditAccountError.invalidEmail }
        
        // Vérifier si l'email existe déjà et n'appartient pas à l'utilisateur actuel
        let fetchDescriptor = FetchDescriptor<User>(predicate: #Predicate { $0.email == newEmail })
        
        if let existingUser = try context.fetch(fetchDescriptor).first {
            guard existingUser.id == user.id else { throw EditAccountError.emailAlreadyTaken }
        }

        // Mise à jour des informations
        user.username = newUsername
        user.email = newEmail
        try context.save()
    }
}

enum SignUpError: Error, LocalizedError {
    case emptyUsername
    case invalidEmail
    case passwordMismatch
    case weakPassword
    case emailAlreadyExists

    var errorDescription: String? {
        switch self {
        case .emptyUsername:
            return "Le nom d'utilisateur est requis."
        case .invalidEmail:
            // On peut préciser que le premier caractère doit être en minuscule
            return "L'adresse email n'est pas valide ou ne commence pas par une minuscule."
        case .passwordMismatch:
            return "Les mots de passe ne correspondent pas."
        case .weakPassword:
            // On explique la règle en détail
            return """
            Le mot de passe doit comporter au minimum 8 caractères, \
            incluant une majuscule, une minuscule et un chiffre.
            """
        case .emailAlreadyExists:
            return "Un compte avec cet email existe déjà."
        }
    }
}

// MARK: - EditAccountError
// Enum pour les erreurs de modification de compte
enum EditAccountError: Error, LocalizedError {
    case emptyUsername
    case invalidEmail
    case emailAlreadyTaken

    var errorDescription: String? {
        switch self {
        case .emptyUsername: return "Le nom d'utilisateur est requis."
        case .invalidEmail: return "L'adresse email n'est pas valide."
        case .emailAlreadyTaken: return "Cet email est déjà utilisé."
        }
    }
}

// MARK: - Extensions
// Extensions pour les validations
extension String {
    
    /// Vérifie que l'email a une forme standard + commence obligatoirement par une minuscule ou un chiffre
    var isValidEmail: Bool {
        // Ici, on impose :
        // 1) Le premier caractère doit être a-z ou 0-9 (pas de majuscule)
        // 2) Puis on autorise lettres maj/min, chiffres, ., _, %, +, -, ...
        // 3) @
        // 4) Domaine
        // 5) TLD de 2 caractères minimum
        let emailRegex = "^[a-z0-9][A-Za-z0-9._%+-]*@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }

    /// Vérifie que le mot de passe a au moins 8 caractères,
    /// incluant minuscule, majuscule et chiffre
    var isStrongPassword: Bool {
        // Regex :
        // - au moins 8 caractères
        // - au moins 1 majuscule
        // - au moins 1 minuscule
        // - au moins 1 chiffre
        // - peut contenir caractères spéciaux autorisés
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d$@$!%*?&]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }

    func hash() -> String {
        // Exemple de hachage SHA256
        guard let data = self.data(using: .utf8) else { return self }
        let hashed = data.map { String(format: "%02hhx", $0) }.joined()
        return hashed
    }
}
