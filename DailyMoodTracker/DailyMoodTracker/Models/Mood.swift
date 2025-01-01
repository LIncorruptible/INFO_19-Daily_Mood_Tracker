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
    var text: String
    var level: Int
    
    // Image optionnelle (nom d'asset), peut être nil
    var image: String?
    
    // Données binaires si l’utilisateur a importé une photo
    var userImageData: Data?

    init(
        id: UUID = UUID(),
        name: String,
        text: String,
        level: Int,
        image: String? = nil,
        userImageData: Data? = nil
    ) {
        self.id = id
        self.name = name
        self.text = text
        self.level = level
        self.image = image
        self.userImageData = userImageData
    }
}
