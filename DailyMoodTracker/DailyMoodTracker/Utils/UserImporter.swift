//
//  UserImporter.swift
//  DailyMoodTracker
//
//  Created by etudiant on 01/01/2025.
//

import SwiftUI
import SwiftData

struct UserData: Codable {
    var username: String
    var email: String
    var password: String
    var dateCreated: String
}

class UserImporter {
    // MARK: - Import JSON
    static func importFromJSON() -> [User] {
        let url = Bundle.main.url(forResource: "users", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        let users = try! decoder.decode([UserData].self, from: data)
        
        var usersToReturn = [User]()
        let dateFormatter = ISO8601DateFormatter()
        
        for user in users {
            // Conversion de la date
            guard let date = dateFormatter.date(from: user.dateCreated) else {
                print("Erreur : Format de date invalide pour l'utilisateur \(user.username).")
                continue
            }
            
            usersToReturn.append(User(
                username: user.username,
                email: user.email,
                password: user.password,
                dateCreated: date
            ))
        }
        
        return usersToReturn
    }
}
