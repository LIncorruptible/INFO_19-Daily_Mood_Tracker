//
//  Journal.swift
//  DailyMoodTracker
//
//  Created by etudiant on 10/12/2024.
//


import Foundation
import SwiftData

@Model
class Journal {
    @Attribute(.unique) var id: UUID
    var date: Date
    var notes: String
    @Relationship var mood: Mood?
    @Relationship var user: User

    init(id: UUID = UUID(), date: Date, notes: String, mood: Mood, user: User) {
        self.id = id
        self.date = date
        self.notes = notes
        self.mood = mood
        self.user = user
    }
}
