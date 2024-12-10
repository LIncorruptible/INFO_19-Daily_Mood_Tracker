//
//  User.swift
//  DailyMoodTracker
//
//  Created by etudiant on 10/12/2024.
//


import Foundation
import SwiftData

@Model
class User {
    @Attribute(.unique) var id: UUID
    var username: String
    var email: String
    var password: String
    var dateCreated: Date

    init(id: UUID = UUID(), username: String, email: String, password: String, dateCreated: Date = Date()) {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
        self.dateCreated = dateCreated
    }
}
