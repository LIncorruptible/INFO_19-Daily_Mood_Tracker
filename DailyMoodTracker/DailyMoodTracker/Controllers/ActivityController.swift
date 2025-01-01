//
//  ActivityController.swift
//  DailyMoodTracker
//
//  Created by etudiant on 01/01/2025.
//

import Foundation
import SwiftData

class ActivityController {
    
    // MARK: - Context
    var context: ModelContext
    
    // MARK: - Constructeur
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - getAll
    // Récupération de toutes les activités
    func getAll() throws -> [Activity] {
        let fetchDescriptor = FetchDescriptor<Activity>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            throw ActivityError.fetchFailed("Erreur lors de la récupération de toutes les activités : \(error.localizedDescription)")
        }
    }

    // MARK: - getById
    // Récupération d'une activité spécifique par son ID
    func getById(byId id: UUID) throws -> Activity? {
        let fetchDescriptor = FetchDescriptor<Activity>(predicate: #Predicate { $0.id == id })
        do {
            let activities = try context.fetch(fetchDescriptor)
            guard let activity = activities.first else {
                throw ActivityError.activityNotFound("Activité avec l'ID \(id) non trouvée.")
            }
            return activity
        } catch {
            throw ActivityError.fetchFailed("Erreur lors de la récupération de l'activité avec l'ID \(id): \(error.localizedDescription)")
        }
    }
    
    // MARK: - deleteAll
    // Suppression de toutes les activités
    func deleteAll() throws {
        let fetchDescriptor = FetchDescriptor<Activity>() // Récupère toutes les activités
        do {
            let activities = try context.fetch(fetchDescriptor)
            for activity in activities {
                context.delete(activity)
            }
            try context.save()
            print("Toutes les activités ont été supprimées avec succès.")
        } catch {
            throw ActivityError.deletionFailed("Erreur lors de la suppression de toutes les activités : \(error.localizedDescription)")
        }
    }
    
    // MARK: - deleteById
    // Suppression d'une activité spécifique par son ID
    func deleteById(byId id: UUID) throws {
        let fetchDescriptor = FetchDescriptor<Activity>(predicate: #Predicate { $0.id == id })
        do {
            let activities = try context.fetch(fetchDescriptor)
            guard let activity = activities.first else {
                throw ActivityError.activityNotFound("Activité avec l'ID \(id) non trouvée.")
            }
            context.delete(activity)
            try context.save()
            print("L'activité avec l'ID \(id) a été supprimée avec succès.")
        } catch {
            throw ActivityError.deletionFailed("Erreur lors de la suppression de l'activité avec l'ID \(id) : \(error.localizedDescription)")
        }
    }
    
    // MARK: - create
    // Enregistrement d'une activité
    func create(activity: Activity) throws {
        context.insert(activity)
        do {
            try context.save()
        } catch {
            throw ActivityError.saveFailed("Erreur lors de la sauvegarde de l'activité : \(error.localizedDescription)")
        }
    }
    
    // MARK: - createMany
    // Enregistrement de plusieurs activités
    func createMany(activities: [Activity]) throws {
        for activity in activities {
            context.insert(activity)
        }
        do {
            try context.save()
            print("Activités enregistrées.")
        } catch {
            throw QuoteError.saveFailed("Erreur lors de l'enregistrement des activités : \(error.localizedDescription)")
        }
    }
    
    // MARK: - update
    // Mise à jour d'une activité
    func update(activity: Activity) throws {
        
        // Récupération de l'activité par son ID
        let activityToUpdate = try getById(byId: activity.id)
        
        // Modificiation des informations
        activityToUpdate?.frenchTitle = activity.frenchTitle
        activityToUpdate?.englishTitle = activity.englishTitle
        activityToUpdate?.frenchText = activity.frenchText
        activityToUpdate?.englishText = activity.englishText
        activityToUpdate?.completionTimes = activity.completionTimes
        activityToUpdate?.minMoodLevel = activity.minMoodLevel
        activityToUpdate?.maxMoodLevel = activity.maxMoodLevel
        
        do {
            try context.save()
        } catch {
            throw ActivityError.saveFailed("Erreur lors de la mise à jour de l'activité : \(error.localizedDescription)")
        }
    }
}

// MARK: - ActivityError
// Enumération pour le erreurs
enum ActivityError: Error, LocalizedError {
    case activityNotFound(String)
    case fetchFailed(String)
    case deletionFailed(String)
    case saveFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .activityNotFound(let message):
            return message
        case .fetchFailed(let message):
            return message
        case .deletionFailed(let message):
            return message
        case .saveFailed(let message):
            return message
        }
    }
}
