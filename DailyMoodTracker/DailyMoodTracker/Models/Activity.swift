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
    var completionTimes: Int
    var minMoodLevel: Int
    var maxMoodLevel: Int

    init(id: Int, frenchTitle: String, englishTitle: String, frenchText: String, englishText: String, completionTimes: Int, minMoodLevel: Int, maxMoodLevel: Int) {
        self.id = id
        self.frenchTitle = frenchTitle
        self.englishTitle = englishTitle
        self.frenchText = frenchText
        self.englishText = englishText
        self.completionTimes = completionTimes
        self.minMoodLevel = minMoodLevel
        self.maxMoodLevel = maxMoodLevel
    }
}
