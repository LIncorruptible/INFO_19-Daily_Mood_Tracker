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
    let titreFR: String
    let titreEN: String
    let texteFR: String
    let texteEN: String
    let tempsRealisation: Int16
    let niveauHumeurMin: Int16
    let niveauHumeurMax: Int16
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
                    frenchTitle: activityData.titreFR,
                    englishTitle: activityData.titreEN,
                    frenchText: activityData.texteFR,
                    englishText: activityData.texteEN,
                    duration: activityData.tempsRealisation,
                    minMoodLevel: activityData.niveauHumeurMin,
                    maxMoodLevel: activityData.niveauHumeurMax
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
