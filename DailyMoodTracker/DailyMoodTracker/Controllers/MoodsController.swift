//
//  MoodsController.swift
//  DailyMoodTracker
//
//  Created by etudiant on 30/12/2024.
//


import SwiftData
import SwiftUI

class MoodsController: ObservableObject {
    
    func getMood(byId id: UUID, context: ModelContext) throws -> Mood? {
        let fetchDescriptor = FetchDescriptor<Mood>(predicate: #Predicate { $0.id == id }) // Filtre par ID
        do {
            let moods = try context.fetch(fetchDescriptor)
            return moods.first
        } catch {
            throw MoodError.fetchFailed("Erreur lors de la récupération de l’humeur avec l'ID \(id): \(error.localizedDescription)")
        }
    }
    
    /// Crée une nouvelle humeur dans SwiftData
    func addNewMood(
        name: String,
        text: String,
        level: Int,
        imageData: Data?,
        context: ModelContext
    ) {
        let mood = Mood(
            name: name,
            text: text,
            level: level,
            userImageData: imageData
        )
        context.insert(mood)
        
        do {
            try context.save()
            print("Nouvelle humeur enregistrée.")
        } catch {
            print("Erreur lors de l’enregistrement : \(error)")
        }
    }
    
    /// Met à jour une humeur existante
    func updateMood(
        _ mood: Mood,
        newName: String,
        newText: String,
        newLevel: Int,
        newImageData: Data?,
        context: ModelContext
    ) {
        mood.name = newName
        mood.text = newText
        mood.level = newLevel
        mood.userImageData = newImageData
        
        do {
            try context.save()
            print("Humeur mise à jour.")
        } catch {
            print("Erreur lors de la mise à jour : \(error)")
        }
    }
    
    /// Supprime une humeur de la base
    func deleteMood(
        _ mood: Mood,
        context: ModelContext
    ) {
        context.delete(mood)
        do {
            try context.save()
            print("Humeur supprimée.")
        } catch {
            print("Erreur lors de la suppression : \(error)")
        }
    }
    
    /// Récupère toutes les humeurs
    func fetchAllMoods(context: ModelContext) -> [Mood] {
        let fetchDescriptor = FetchDescriptor<Mood>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Erreur lors de la récupération des humeurs : \(error)")
            return []
        }
    }
}

// MARK: - Enum des erreurs possibles pour UserController
enum MoodError: Error, LocalizedError {
    case fetchFailed(String)
    case moodNotFound(String)
    case deletionFailed(String)

    var errorDescription: String? {
        switch self {
        case .fetchFailed(let message):
            return message
        case .moodNotFound(let message):
            return message
        case .deletionFailed(let message):
            return message
        }
    }
}
