//
//  UserImporter.swift
//  DailyMoodTracker
//
//  Created by etudiant on 01/01/2025.
//

import SwiftUI
import SwiftData

struct UserData: Codable {
    let username: String
    let email: String
    let password: String
    let dateCreated: String
}

class UserImporter {
    static func importUsers(from jsonFile: String, context: ModelContext) {
        guard let url = Bundle.main.url(forResource: jsonFile, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Erreur : Fichier JSON introuvable.")
            return
        }

        do {
            let decoder = JSONDecoder()
            let usersArray = try decoder.decode([UserData].self, from: data)

            for userData in usersArray {
                let newUser = User(
                    username: userData.username,
                    email: userData.email,
                    password: userData.password,
                    dateCreated: ISO8601DateFormatter().date(from: userData.dateCreated) ?? Date()
                )
                context.insert(newUser)
            }

            try context.save()
            print("Utilisateurs importés avec succès.")
        } catch {
            print("Erreur lors de l'importation des utilisateurs : \(error)")
        }
    }
}
