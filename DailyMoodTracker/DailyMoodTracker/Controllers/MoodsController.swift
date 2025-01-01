//
//  MoodsController.swift
//  DailyMoodTracker
//
//  Created by etudiant on 30/12/2024.
//


import SwiftData
import SwiftUI

class MoodsController: ObservableObject {
    
    /// Crée une nouvelle humeur dans SwiftData
    func addNewMood(
        name: String,
        text: String,
        level: Int16,
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
        newLevel: Int16,
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
}
