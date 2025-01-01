//
//  Quote.swift
//  DailyMoodTracker
//
//  Created by etudiant on 01/01/2025.
//

import Foundation
import SwiftData

class QuoteController {
        
    // MARK: - Context
    var context: ModelContext
    
    // MARK: - Constructeur
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - getAll
    // Récupération de tous les citations
    func getAll() throws -> [Quote] {
        let fetchDescriptor = FetchDescriptor<Quote>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            throw QuoteError.fetchFailed("Erreur lors de la récupération de toutes les citations : \(error.localizedDescription)")
        }
    }

    // MARK: - getById
    // Récupération d'un citation spécifique par son ID
    func getById(byId id: UUID) throws -> Quote? {
        let fetchDescriptor = FetchDescriptor<Quote>(predicate: #Predicate { $0.id == id })
        do {
            let quotes = try context.fetch(fetchDescriptor)
            guard let quote = quotes.first else {
                throw QuoteError.quoteNotFound("Citation avec l'ID \(id) non trouvé.")
            }
            return quote
        } catch {
            throw QuoteError.fetchFailed("Erreur lors de la récupération de la citation avec l'ID \(id): \(error.localizedDescription)")
        }
    }
    
    // MARK: - getRandom
    // Récupération d'une citation aléatoire
    func getRandom() throws -> Quote {
        let fetchDescriptor = FetchDescriptor<Quote>()
        do {
            let quotes = try context.fetch(fetchDescriptor)
            guard let quote = quotes.randomElement() else {
                throw QuoteError.quoteNotFound("Aucune citation trouvée.")
            }
            return quote
        } catch {
            throw QuoteError.fetchFailed("Erreur lors de la récupération d'une citation aléatoire : \(error.localizedDescription)")
        }
    }
    
    // MARK: - deleteAll
    // Suppression de toutes les citations
    func deleteAll() throws {
        let fetchDescriptor = FetchDescriptor<Quote>() // Récupère tous les citations
        do {
            let quotes = try context.fetch(fetchDescriptor)
            for quote in quotes {
                context.delete(quote)
            }
            try context.save()
            print("Tous les citations ont été supprimés avec succès.")
        } catch {
            throw QuoteError.deletionFailed("Erreur lors de la suppression de toutes les citations : \(error.localizedDescription)")
        }
    }

    // MARK: - deleteById
    // Suppression d'une citation spécifique par son ID
    func deleteById(byId id: UUID) throws {
        let fetchDescriptor = FetchDescriptor<Quote>(predicate: #Predicate { $0.id == id })
        do {
            let quotes = try context.fetch(fetchDescriptor)
            guard let quote = quotes.first else {
                throw QuoteError.quoteNotFound("Citation avec l'ID \(id) non trouvé.")
            }
            context.delete(quote)
            try context.save()
            print("Citation avec l'ID \(id) a été supprimée avec succès.")
        } catch {
            throw QuoteError.deletionFailed("Erreur lors de la suppression de la citation avec l'ID \(id) : \(error.localizedDescription)")
        }
    }
    
    // MARK: - create
    // Enregistrement d'une citation
    func create(quote: Quote) throws {
        context.insert(quote)
        do {
            try context.save()
            print("Citation enregistrée.")
        } catch {
            throw QuoteError.saveFailed("Erreur lors de l'enregistrement de la citation : \(error.localizedDescription)")
        }
    }
    
    // MARK: - createMany
    // Enregistrement de plusieurs citations
    func createMany(quotes: [Quote]) throws {
        for quote in quotes {
            context.insert(quote)
        }
        do {
            try context.save()
            print("Citations enregistrées.")
        } catch {
            throw QuoteError.saveFailed("Erreur lors de l'enregistrement des citations : \(error.localizedDescription)")
        }
    }
    
    // MARK: - update
    // Mise à jour d'une citation
    func update(quote: Quote) throws {
        
        // Récupération de la citation par son ID
        let quoteToUpdate = try getById(byId: quote.id)
        
        // Modification des informations
        quoteToUpdate?.title = quote.title
        quoteToUpdate?.author = quote.author
        quoteToUpdate?.frenchText = quote.frenchText
        quoteToUpdate?.englishText = quote.englishText
        
        do {
            try context.save()
        } catch {
            throw QuoteError.saveFailed("Erreur lors de la modification de la citation : \(error.localizedDescription)")
        }
    }
}

// MARK: - QuoteError
// Enumérations pour les erreurs
enum QuoteError: Error, LocalizedError {
    case fetchFailed(String)
    case quoteNotFound(String)
    case deletionFailed(String)
    case saveFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .fetchFailed(let message):
            return message
        case .quoteNotFound(let message):
            return message
        case .deletionFailed(let message):
            return message
        case .saveFailed(let message):
            return message
        }
    }
}
