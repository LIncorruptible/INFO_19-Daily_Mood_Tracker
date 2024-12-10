//
//  Mood.swift
//  DailyMoodTracker
//
//  Created by etudiant on 10/12/2024.
//


import Foundation
import SwiftData

@Model
class Mood {
    @Attribute(.unique) var id: UUID
    var name: String
    var text : String
    var image: String
    var level: Int16

    init(id: UUID = UUID(), name: String, text: String, image: String, level: Int16) {
        self.id = id
        self.name = name
        self.text = text
        self.image = image
        self.level = level
    }
}
