//
//  Mood.swift
//  DailyMoodTracker
//
//  Created by etudiant on 10/12/2024.
//

import Foundation
import SwiftData

@Model
class Mood: Identifiable, Hashable {
    @Attribute(.unique) var id: UUID
    var name: String
    var text: String
    var level: Int
    
    // Image optionnelle (nom d'asset), peut être nil
    var image: String?
    
    // Données binaires si l’utilisateur a importé une photo
    var userImageData: Data?
    
    var userId: UUID?

    // MARK: - Constructeur par défaut
    init(
        id: UUID = UUID(),
        name: String,
        text: String,
        level: Int,
        image: String? = nil,
        userImageData: Data? = nil,
        userId: UUID? = nil
    ) {
        self.id = id
        self.name = name
        self.text = text
        self.level = level
        self.image = image
        self.userImageData = userImageData
        self.userId = userId
    }
    
    // MARK: - Hash
    // Permet de comparer les instances de Mood
    static func == (lhs: Mood, rhs: Mood) -> Bool {
        return lhs.id == rhs.id
    }
    
    // MARK: - Hashable
    // Permet de hasher les instances de Mood
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
