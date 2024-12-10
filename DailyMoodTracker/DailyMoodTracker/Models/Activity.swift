//
//  Activity.swift
//  DailyMoodTracker
//
//  Created by etudiant on 10/12/2024.
//


import Foundation
import SwiftData

@Model
class Activity {
    @Attribute(.unique) var id: Int
    var frenchTitle: String
    var englishTitle: String
    var frenchText: String
    var englishText: String
    var duration: Int16
    var minMoodLevel: Int16
    var maxMoodLevel: Int16

    init(id: Int, frenchTitle: String, englishTitle: String, frenchText: String, englishText: String, duration: Int16, minMoodLevel: Int16, maxMoodLevel: Int16) {
        self.id = id
        self.frenchTitle = frenchTitle
        self.englishTitle = englishTitle
        self.frenchText = frenchText
        self.englishText = englishText
        self.duration = duration
        self.minMoodLevel = minMoodLevel
        self.maxMoodLevel = maxMoodLevel
    }
}
