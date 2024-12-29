//
//  UserController.swift
//  DailyMoodTracker
//
//  Created by etudiant on 29/12/2024.
//


import Foundation
import SwiftData

class UserController {
    // MARK: - Récupération de tous les utilisateurs
    func getAllUsers(context: ModelContext) throws -> [User] {
        let fetchDescriptor = FetchDescriptor<User>() // Récupère tous les utilisateurs
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            throw UserError.fetchFailed("Erreur lors de la récupération de tous les utilisateurs : \(error.localizedDescription)")
        }
    }

    // MARK: - Récupération d'un utilisateur spécifique
    func getUser(byId id: UUID, context: ModelContext) throws -> User? {
        let fetchDescriptor = FetchDescriptor<User>(predicate: #Predicate { $0.id == id }) // Filtre par ID
        do {
            let users = try context.fetch(fetchDescriptor)
            return users.first
        } catch {
            throw UserError.fetchFailed("Erreur lors de la récupération de l'utilisateur avec l'ID \(id): \(error.localizedDescription)")
        }
    }

    // MARK: - Suppression d'un utilisateur spécifique
    func deleteUser(byId id: UUID, context: ModelContext) throws {
        let fetchDescriptor = FetchDescriptor<User>(predicate: #Predicate { $0.id == id }) // Filtre par ID
        do {
            let users = try context.fetch(fetchDescriptor)
            guard let user = users.first else {
                throw UserError.userNotFound("Utilisateur avec l'ID \(id) non trouvé.")
            }
            context.delete(user)
            try context.save()
            print("Utilisateur avec l'ID \(id) supprimé avec succès.")
        } catch {
            throw UserError.deletionFailed("Erreur lors de la suppression de l'utilisateur avec l'ID \(id): \(error.localizedDescription)")
        }
    }

    // MARK: - Suppression de tous les utilisateurs
    func deleteAllUsers(context: ModelContext) throws {
        let fetchDescriptor = FetchDescriptor<User>() // Récupère tous les utilisateurs
        do {
            let users = try context.fetch(fetchDescriptor)
            for user in users {
                context.delete(user)
            }
            try context.save()
            print("Tous les utilisateurs ont été supprimés avec succès.")
        } catch {
            throw UserError.deletionFailed("Erreur lors de la suppression de tous les utilisateurs : \(error.localizedDescription)")
        }
    }
}

// MARK: - Enum des erreurs possibles pour UserController
enum UserError: Error, LocalizedError {
    case fetchFailed(String)
    case userNotFound(String)
    case deletionFailed(String)

    var errorDescription: String? {
        switch self {
        case .fetchFailed(let message):
            return message
        case .userNotFound(let message):
            return message
        case .deletionFailed(let message):
            return message
        }
    }
}
