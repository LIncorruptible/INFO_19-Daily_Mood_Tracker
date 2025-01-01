//
//  JournalController.swift
//  DailyMoodTracker
//
//  Created by etudiant on 01/01/2025.
//

import Foundation
import SwiftData

class JournalController {
    func fetchAllEntries(context: ModelContext) -> [Journal] {
        let fetchDescriptor = FetchDescriptor<Journal>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Erreur lors de la récupération des entrées du journal : \(error)")
            return []
        }
    }

    func addEntry(date: Date, notes: String, mood: Mood, user: User, context: ModelContext) {
        let newEntry = Journal(date: date, notes: notes, mood: mood, user: user)
        context.insert(newEntry)
        saveContext(context: context)
    }

    func updateEntry(entry: Journal, date: Date, notes: String, mood: Mood, context: ModelContext) {
        entry.date = date
        entry.notes = notes
        entry.mood = mood
        saveContext(context: context)
    }

    func deleteEntry(entry: Journal, context: ModelContext) {
        context.delete(entry)
        saveContext(context: context)
    }

    private func saveContext(context: ModelContext) {
        do {
            try context.save()
        } catch {
            print("Erreur lors de la sauvegarde : \(error)")
        }
    }
}
