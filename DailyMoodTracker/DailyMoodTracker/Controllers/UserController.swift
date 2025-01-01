//
//  UserController.swift
//  DailyMoodTracker
//
//  Created by etudiant on 29/12/2024.
//

import Foundation
import SwiftData

class UserController {
    
    // MARK: - Context
    var context: ModelContext
    
    // MARK: - Constructeur
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - getAll
    // Récupération de tous les utilisateurs
    func getAll() throws -> [User] {
        let fetchDescriptor = FetchDescriptor<User>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            throw UserError.fetchFailed("Erreur lors de la récupération de tous les utilisateurs : \(error.localizedDescription)")
        }
    }

    // MARK: - getById
    // Récupération d'un utilisateur spécifique par son ID
    func getById(byId id: UUID) throws -> User? {
        let fetchDescriptor = FetchDescriptor<User>(predicate: #Predicate { $0.id == id })
        do {
            let users = try context.fetch(fetchDescriptor)
            guard let user = users.first else {
                throw UserError.userNotFound("Utilisateur avec l'ID \(id) non trouvé.")
            }
            return user
        } catch {
            throw UserError.fetchFailed("Erreur lors de la récupération de l'utilisateur avec l'ID \(id): \(error.localizedDescription)")
        }
    }
    
    // MARK: - deleteAll
    // Suppression de tous les utilisateurs
    func deleteAll() throws {
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

    // MARK: - deleteById
    // Suppression d'un utilisateur spécifique par son ID
    func deleteById(byId id: UUID) throws {
        let fetchDescriptor = FetchDescriptor<User>(predicate: #Predicate { $0.id == id })
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
    
    // MARK: - create
    // Enregistrement d'un nouvel utilisateur
    func create(user: User) throws {
        context.insert(user)
        do {
            try context.save()
            print("Utilisateur enregistré avec succès.")
        } catch {
            throw UserError.saveFailed("Erreur lors de l'enregistrement de l'utilisateur : \(error.localizedDescription)")
        }
    }
    
    // MARK: - update
    // Mise à jour d'un utilisateur
    func update(user: User) throws {
        
        // Récupération de l'utilisateur par son ID
        let userToUpdate = try getById(byId: user.id)
        
        // Mise à jour des informations
        userToUpdate?.username = user.username
        userToUpdate?.password = user.password
        userToUpdate?.email = user.email
        userToUpdate?.dateCreated = user.dateCreated
        
        do {
            try context.save()
            print("Utilisateur mis à jour avec succès.")
        } catch {
            throw UserError.saveFailed("Erreur lors de la mise à jour de l'utilisateur : \(error.localizedDescription)")
        }
    }
}

// MARK: - UserError
// Enumérations pour les erreurs
enum UserError: Error, LocalizedError {
    case fetchFailed(String)
    case userNotFound(String)
    case deletionFailed(String)
    case saveFailed(String)

    var errorDescription: String? {
        switch self {
        case .fetchFailed(let message):
            return message
        case .userNotFound(let message):
            return message
        case .deletionFailed(let message):
            return message
        case .saveFailed(let message):
            return message
        }
    }
}
