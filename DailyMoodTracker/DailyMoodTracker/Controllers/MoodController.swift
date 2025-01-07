//
//  MoodController.swift
//  DailyMoodTracker
//
//  Created by etudiant on 29/12/2024.
//

import SwiftData
import SwiftUI

// MARK: - MoodController
// Classe pour la gestion des humeurs
// Implémente ObservableObject pour la liaison avec SwiftUI
class MoodController: ObservableObject {
    
    // MARK: - Context
    var context: ModelContext
    
    // MARK: - Constructeur
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - getAll
    // Récupération de tous les humeurs
    func getAll(withoutDefault: Bool = false, userId: UUID? = nil) throws -> [Mood] {
        let fetchDescriptor = FetchDescriptor<Mood>()
        do {
            var moods = try context.fetch(fetchDescriptor)
            // Si sans défaut, filtre les humeurs par défaut
            if withoutDefault {
                print("Sans défaut")
                moods = moods.filter { !isDefaultMood($0) }
            }
            // Si un ID utilisateur est spécifié, filtre pour cet utilisateur
            if let userId = userId {
                moods = moods.filter { $0.userId == userId || isDefaultMood($0) }
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
        
        guard !hasJournals(mood: mood) else {
            throw MoodError.hasJournals("Impossible de supprimer une humeur utilisée dans un ou plusieurs journaux.")
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
        
        guard !alreadyExists(name: mood.name, userId: mood.userId) else {
            throw MoodError.alreadyExists("Une humeur avec le nom '\(mood.name)' existe déjà.")
        }
        
        context.insert(mood)
        do {
            try context.save()
            print("Humeur créée avec succès.")
        } catch {
            throw MoodError.saveFailed("Erreur lors de la création de l'humeur : \(error.localizedDescription)")
        }
    }
    
    // MARK: - createMany
    // Création de plusieurs humeurs
    func createMany(moods: [Mood]) throws {
        for mood in moods {
            context.insert(mood)
        }
        do {
            try context.save()
            print("Humeurs créées.")
        } catch {
            throw MoodError.saveFailed("Erreur lors de la création des humeurs : \(error.localizedDescription)")
        }
    }
    
    // MARK: - update
    // Mise à jour d'une humeur
    func update(mood: Mood) throws {
        guard let moodToUpdate = try getById(byId: mood.id) else {
            throw MoodError.moodNotFound("Humeur avec l'ID \(mood.id) non trouvé.")
        }
        
        guard !isDefaultMood(moodToUpdate) else {
            throw MoodError.isDefaultMood("Impossible de modifier une humeur par défaut.")
        }
        
        guard !creatingADuplicate(name: mood.name, ignoredId: mood.id, userId: mood.userId) else {
            throw MoodError.creatingADuplicate("Une humeur avec le nom '\(mood.name)' existe déjà.")
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
        return DefaultMoods.all.contains(where: { $0.name == mood.name })
    }
    
    // MARK: - alreadyExists
    // Vérifie si une humeur existe déjà (par défaut ou personnalisée)
    func alreadyExists(name: String, userId: UUID? = nil) -> Bool {
        // Vérifie d'abord dans les humeurs par défaut
        if DefaultMoods.all.contains(where: { $0.name == name }) {
            return true
        }
        
        // Ensuite, vérifie dans les humeurs personnalisées
        let fetchDescriptor = FetchDescriptor<Mood>(predicate: #Predicate { $0.name == name })
        do {
            let moods = try context.fetch(fetchDescriptor)
            // Si un ID utilisateur est spécifié, vérifie pour cet utilisateur
            if let userId = userId {
                return moods.contains(where: { $0.userId == userId })
            } else {
                return !moods.isEmpty
            }
        } catch {
            // En cas d'erreur de récupération, suppose que le nom existe pour éviter les doublons
            return true
        }
    }
    
    // MARK: - hasJournals
    // Vérifie si une humeur est utilisée dans un ou plusieurs journaux
    func hasJournals(mood: Mood) -> Bool {
        let journalController = JournalController(context: context)
        do {
            let journals = try journalController.getAll()
            return journals.contains(where: { $0.mood == mood })
        } catch {
            return false
        }
    }
    
    // MARK: - creatingADuplicate
    // Vérifie si une humeur créée un doublon (par défaut ou personnalisée) en ignorant un ID spécifique
    func creatingADuplicate(name: String, ignoredId: UUID, userId: UUID? = nil) -> Bool {
        // Vérifie d'abord dans les humeurs par défaut
        if DefaultMoods.all.contains(where: { $0.name == name && $0.id != ignoredId }) {
            return true
        }
        
        // Ensuite, vérifie dans les humeurs personnalisées en ignorant l'ID spécifié
        let fetchDescriptor = FetchDescriptor<Mood>(predicate: #Predicate { $0.name == name && $0.id != ignoredId })
        do {
            let moods = try context.fetch(fetchDescriptor)
            
            // Si un ID utilisateur est spécifié, vérifie pour cet utilisateur
            if let userId = userId {
                return moods.contains(where: { $0.userId == userId })
            } else {
                return !moods.isEmpty
            }
        } catch {
            // En cas d'erreur de récupération, suppose que le nom existe pour éviter les doublons
            return true
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
    case isDefaultMood(String)
    case alreadyExists(String)
    case hasJournals(String)
    case creatingADuplicate(String)

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
        case .isDefaultMood(let message):
            return message
        case .alreadyExists(let message):
            return message
        case .hasJournals(let message):
            return message
        case .creatingADuplicate(let message):
            return message
        }
    }
}
