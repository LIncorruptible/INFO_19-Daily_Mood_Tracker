//
//  JournalController.swift
//  DailyMoodTracker
//
//  Created by etudiant on 01/01/2025.
//

import Foundation
import SwiftData

class JournalController {
    
    // MARK: - Context
    var context: ModelContext
    
    // MARK: - Constructeur
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - getAll
    // Récupération de tous les journaux
    func getAll() throws -> [Journal] {
        let fetchDescriptor = FetchDescriptor<Journal>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            throw JournalError.fetchFailed("Erreur lors de la récupération de tous les journaux : \(error.localizedDescription)")
        }
    }
    
    // MARK: - getById
    // Récupération d'un journal spécifique par son ID
    func getById(byId id: UUID) throws -> Journal? {
        let fetchDescriptor = FetchDescriptor<Journal>(predicate: #Predicate { $0.id == id })
        do {
            let journals = try context.fetch(fetchDescriptor)
            guard let journal = journals.first else {
                throw JournalError.journalNotFound("Journal avec l'ID \(id) non trouvé.")
            }
            return journal
        } catch {
            throw JournalError.fetchFailed("Erreur lors de la récupération du journal avec l'ID \(id): \(error.localizedDescription)")
        }
    }
    
    // MARK: - getAllByUser
    // Récupération de tous les journaux d'un utilisateur spécifique
    func getAllByUser(byUser user: User) throws -> [Journal] {
        let fetchDescriptor = FetchDescriptor<Journal>(predicate: #Predicate { $0.user == user })
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            throw JournalError.fetchFailed("Erreur lors de la récupération de tous les journaux de l'utilisateur : \(error.localizedDescription)")
        }
    }
    
    // MARK: - getLatestByUser
    // Récupération du dernier journal d'un utilisateur spécifique
    func getLatestByUser(byUser user: User) throws -> Journal? {
        let fetchDescriptor = FetchDescriptor<Journal>(
            predicate: #Predicate { $0.user == user },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        do {
            let journals = try context.fetch(fetchDescriptor)
            return journals.first // Retourne le premier journal dans l'ordre décroissant des dates
        } catch {
            throw JournalError.fetchFailed("Erreur lors de la récupération du dernier journal de l'utilisateur : \(error.localizedDescription)")
        }
    }
    
    // MARK: - deleteAll
    // Suppression de tous les journaux
    func deleteAll() throws {
        let fetchDescriptor = FetchDescriptor<Journal>() // Récupère tous les journaux
        do {
            let journals = try context.fetch(fetchDescriptor)
            for journal in journals {
                context.delete(journal)
            }
            try context.save()
            print("Tous les journaux ont été supprimés avec succès.")
        } catch {
            throw JournalError.deletionFailed("Erreur lors de la suppression de tous les journaux : \(error.localizedDescription)")
        }
    }
    
    // MARK: - deleteById
    // Suppression d'un journal spécifique par son ID
    func deleteById(byId id: UUID) throws {
        let fetchDescriptor = FetchDescriptor<Journal>(predicate: #Predicate { $0.id == id })
        do {
            let journals = try context.fetch(fetchDescriptor)
            guard let journal = journals.first else {
                throw JournalError.journalNotFound("Journal avec l'ID \(id) non trouvé.")
            }
            context.delete(journal)
            try context.save()
            print("Journal avec l'ID \(id) supprimé avec succès.")
        } catch {
            throw JournalError.deletionFailed("Erreur lors de la suppression du journal avec l'ID \(id): \(error.localizedDescription)")
        }
    }
    
    // MARK: - create
    // Création d'un journal
    func create(journal: Journal) throws {
        context.insert(journal)
        do {
            try context.save()
            print("Journal créé avec succès.")
        } catch {
            throw JournalError.saveFailed("Erreur lors de l'enregistrement du journal : \(error.localizedDescription)")
        }
    }
    
    // MARK: - update
    // Mise à jour d'un journal
    func update(journal: Journal) throws {
        
        // Récupération du journal à mettre à jour
        let journalToUpdate = try getById(byId: journal.id)
        
        // Mise à jour des propriétés
        journalToUpdate?.date = journal.date
        journalToUpdate?.notes = journal.notes
        journalToUpdate?.mood = journal.mood
        journalToUpdate?.user = journal.user
        
        do {
            try context.save()
        } catch {
            throw JournalError.saveFailed("Erreur lors de la mise à jour du journal : \(error.localizedDescription)")
        }
    }
}

// MARK: - JournalError
// Enumération pour les erreurs
enum JournalError: Error, LocalizedError {
    case fetchFailed(String)
    case journalNotFound(String)
    case deletionFailed(String)
    case saveFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .fetchFailed(let message): return message
        case .journalNotFound(let message): return message
        case .deletionFailed(let message): return message
        case .saveFailed(let message): return message
        }
    }
}
