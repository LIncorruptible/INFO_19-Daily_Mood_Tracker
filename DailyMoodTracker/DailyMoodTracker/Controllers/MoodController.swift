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
    func getAll(withoutDefault: Bool = false) throws -> [Mood] {
        let fetchDescriptor = FetchDescriptor<Mood>()
        do {
            var moods = try context.fetch(fetchDescriptor)
            if withoutDefault {
                moods = moods.filter { !isDefaultMood($0) }
            }
            return moods
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
        let fetchDescriptor = FetchDescriptor<Mood>()
        do {
            let moods = try context.fetch(fetchDescriptor)
            for mood in moods {
                if !isDefaultMood(mood) {
                    context.delete(mood)
                }
            }
            try context.save()
            print("Toutes les humeurs personnalisées ont été supprimées avec succès.")
        } catch {
            throw MoodError.deletionFailed("Erreur lors de la suppression des humeurs : \(error.localizedDescription)")
        }
    }
    
    // MARK: - deleteById
    // Suppression d'une humeur spécifique par son ID
    func deleteById(byId id: UUID) throws {
        guard let mood = try getById(byId: id) else {
            throw MoodError.moodNotFound("Humeur avec l'ID \(id) non trouvé.")
        }
        
        guard !isDefaultMood(mood) else {
            throw MoodError.deletionFailed("Impossible de supprimer une humeur par défaut.")
        }
        
        context.delete(mood)
        do {
            try context.save()
            print("Humeur avec l'ID \(id) supprimée avec succès.")
        } catch {
            throw MoodError.deletionFailed("Erreur lors de la suppression de l'humeur avec l'ID \(id): \(error.localizedDescription)")
        }
    }
    
    // MARK: - create
    // Création d'une nouvelle humeur
    func create(mood: Mood) throws {
        guard !isDefaultMood(mood) else {
            throw MoodError.saveFailed("Impossible de créer une humeur par défaut.")
        }
        
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
        guard let moodToUpdate = try getById(byId: mood.id) else {
            throw MoodError.moodNotFound("Humeur avec l'ID \(mood.id) non trouvé.")
        }
        
        guard !isDefaultMood(moodToUpdate) else {
            throw MoodError.saveFailed("Impossible de modifier une humeur par défaut.")
        }
        
        moodToUpdate.name = mood.name
        moodToUpdate.text = mood.text
        moodToUpdate.level = mood.level
        moodToUpdate.image = mood.image
        moodToUpdate.userImageData = mood.userImageData
        
        do {
            try context.save()
            print("Humeur mise à jour avec succès.")
        } catch {
            throw MoodError.saveFailed("Erreur lors de la mise à jour de l'humeur : \(error.localizedDescription)")
        }
    }
    // MARK: - isDefaultMood
    // Vérifie si une humeur fait partie des humeurs par défaut
    private func isDefaultMood(_ mood: Mood) -> Bool {
        return DefaultMoods.all.contains(where: { $0.id == mood.id })
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
