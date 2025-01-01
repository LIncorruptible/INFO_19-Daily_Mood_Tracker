//
//  JournalImporter.swift
//  DailyMoodTracker
//
//  Created by etudiant on 01/01/2025.
//

import SwiftUI
import SwiftData

struct JournalData: Codable {
    let date: String // Format ISO8601
    let notes: String
    let moodID: UUID
    let userID: UUID
}

class JournalImporter {
    static func importJournals(from jsonFile: String, context: ModelContext) {
        guard let url = Bundle.main.url(forResource: jsonFile, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Erreur : Fichier JSON introuvable.")
            return
        }

        do {
            let decoder = JSONDecoder()
            let journalsArray = try decoder.decode([JournalData].self, from: data)
            
            let moodController = MoodsController()
            let userController = UserController()

            for journalData in journalsArray {
                
                let mood = try? moodController.getMood(byId: journalData.moodID, context: context)
                let user = try? userController.getUser(byId: journalData.userID, context: context)
                                
                let newJournal = Journal(
                    date: ISO8601DateFormatter().date(from: journalData.date) ?? Date(),
                    notes: journalData.notes,
                    mood: mood!,
                    user: user!
                )
                
                context.insert(newJournal)
            }

            try context.save()
            print("Journaux importés avec succès.")
        } catch {
            print("Erreur lors de l'importation des journaux : \(error)")
        }
    }
}
