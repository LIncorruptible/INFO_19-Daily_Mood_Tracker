//
//  MoodImporter.swift
//  DailyMoodTracker
//
//  Created by etudiant on 01/01/2025.
//

import SwiftUI
import SwiftData

struct MoodData: Codable {
    let name: String
    let text: String
    let level: Int
    let image: String
}

class MoodImporter {
    static func importMoods(from jsonFile: String, context: ModelContext) {
        guard let url = Bundle.main.url(forResource: jsonFile, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Erreur : Fichier JSON introuvable.")
            return
        }

        do {
            let decoder = JSONDecoder()
            let moodsArray = try decoder.decode([MoodData].self, from: data)

            for moodData in moodsArray {
                let newMood = Mood(
                    name: moodData.name,
                    text: moodData.text,
                    level: moodData.level,
                    image: moodData.image
                )
                context.insert(newMood)
            }

            try context.save()
            print("Humeurs importées avec succès.")
        } catch {
            print("Erreur lors de l'importation des humeurs : \(error)")
        }
    }
}
