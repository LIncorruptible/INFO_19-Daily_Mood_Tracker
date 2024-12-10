//
//  Quote.swift
//  DailyMoodTracker
//
//  Created by etudiant on 10/12/2024.
//


import Foundation
import SwiftData

@Model
class Quote {
    @Attribute(.unique) var id: Int
    var title: String
    var author: String
    var frenchText: String
    var englishText: String

    init(id: Int, title: String, author: String, frenchText: String, englishText: String) {
        self.id = id
        self.title = title
        self.author = author
        self.frenchText = frenchText
        self.englishText = englishText
    }
}
