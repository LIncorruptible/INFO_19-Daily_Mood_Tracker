//
//  ActivityData.swift
//  DailyMoodTracker
//
//  Created by etudiant on 10/12/2024.
//


import Foundation
import SwiftData

struct ActivityData: Codable {
    let id: Int
    let frenchTitle: String
    let englishTitle: String
    let frenchText: String
    let englishText: String
    let completionTimes: Int16
    let moodLevelMin: Int16
    let moodLevelMax: Int16
}

class ActivityImporter {
    static func importActivities(from jsonFile: String, context: ModelContext) {
        guard let url = Bundle.main.url(forResource: jsonFile, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Erreur : Fichier JSON introuvable.")
            return
        }

        do {
            let decoder = JSONDecoder()
            let activitiesArray = try decoder.decode([ActivityData].self, from: data)

            for activityData in activitiesArray {
                let newActivity = Activity(
                    id: activityData.id,
                    frenchTitle: activityData.frenchTitle,
                    englishTitle: activityData.englishTitle,
                    frenchText: activityData.frenchText,
                    englishText: activityData.englishText,
                    duration: activityData.completionTimes,
                    minMoodLevel: activityData.moodLevelMin,
                    maxMoodLevel: activityData.moodLevelMax
                )
                context.insert(newActivity)
            }

            try context.save()
            print("Activités importées avec succès.")
        } catch {
            print("Erreur lors de l'importation des activités : \(error)")
        }
    }
}
