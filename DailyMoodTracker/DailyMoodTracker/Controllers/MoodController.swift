//
//  MoodsController.swift
//  DailyMoodTracker
//
//  Created by etudiant on 30/12/2024.
//

import SwiftData
import SwiftUI

class MoodController: ObservableObject {
    
    // MARK: - Context
    var context: ModelContext
    
    // MARK: - Constructeur
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - getAll
    // Récupération de tous les humeurs
    func getAll() throws -> [Mood] {
        let fetchDescriptor = FetchDescriptor<Mood>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            throw MoodError.fetchFailed("Erreur lors de la récupération de toutes les humeurs : \(error.localizedDescription)")
        }
    }
    
    // MARK: - getById
    // Récupération d'une humeur spécifique par son ID
    func getById(byId id: UUID) throws -> Mood? {
        let fetchDescriptor = FetchDescriptor<Mood>(predicate: #Predicate { $0.id == id })
        do {
            let moods = try context.fetch(fetchDescriptor)
            guard let mood = moods.first else {
                throw MoodError.moodNotFound("Humeur avec l'ID \(id) non trouvé.")
            }
            return mood
        } catch {
            throw MoodError.fetchFailed("Erreur lors de la récupération de l'humeur avec l'ID \(id): \(error.localizedDescription)")
        }
    }
    
    // MARK: - deleteAll
    // Suppression de toutes les humeurs
    func deleteAll() throws {
        let fetchDescriptor = FetchDescriptor<Mood>() // Récupère tous les humeurs
        do {
            let moods = try context.fetch(fetchDescriptor)
            for mood in moods {
                context.delete(mood)
            }
            try context.save()
            print("Toutes les humeurs ont été supprimées avec succès.")
        } catch {
            throw MoodError.deletionFailed("Erreur lors de la suppression de toutes les humeurs : \(error.localizedDescription)")
        }
    }
    
    // MARK: - deleteById
    // Suppression d'une humeur spécifique par son ID
    func deleteById(byId id: UUID) throws {
        let fetchDescriptor = FetchDescriptor<Mood>(predicate: #Predicate { $0.id == id })
        do {
            let moods = try context.fetch(fetchDescriptor)
            guard let mood = moods.first else {
                throw MoodError.moodNotFound("Humeur avec l'ID \(id) non trouvé.")
            }
            context.delete(mood)
            try context.save()
            print("Humeur avec l'ID \(id) supprimée avec succès.")
        } catch {
            throw MoodError.deletionFailed("Erreur lors de la suppression de l'humeur avec l'ID \(id): \(error.localizedDescription)")
        }
    }
    
    // MARK: - create
    // Création d'une nouvelle humeur
    func create(mood: Mood) throws {
        context.insert(mood)
        do {
            try context.save()
            print("Humeur créée avec succès.")
        } catch {
            throw MoodError.saveFailed("Erreur lors de la création de l'humeur : \(error.localizedDescription)")
        }
    }
    
    // MARK: - update
    // Mise à jour d'une humeur
    func update(mood: Mood) throws {
        
        // Récupération de l'humeur par son ID
        let moodToUpdate = try getById(byId: mood.id)
        
        // Mise à jour des propriétés
        moodToUpdate?.name = mood.name
        moodToUpdate?.text = mood.text
        moodToUpdate?.level = mood.level
        moodToUpdate?.image = mood.image
        moodToUpdate?.userImageData = mood.userImageData
        
        do {
            try context.save()
        } catch {
            throw MoodError.saveFailed("Erreur lors de la mise à jour de l'humeur : \(error.localizedDescription)")
        }
    }
}

// MARK: - MoodError
// Enumération pour les erreurs
enum MoodError: Error, LocalizedError {
    case fetchFailed(String)
    case moodNotFound(String)
    case deletionFailed(String)
    case saveFailed(String)

    var errorDescription: String? {
        switch self {
        case .fetchFailed(let message):
            return message
        case .moodNotFound(let message):
            return message
        case .deletionFailed(let message):
            return message
        case .saveFailed(let message):
            return message
        }
    }
}
