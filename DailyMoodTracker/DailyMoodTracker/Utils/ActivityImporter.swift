//
//  ActivityData.swift
//  DailyMoodTracker
//
//  Created by etudiant on 10/12/2024.
//

import Foundation
import SwiftData

struct ActivityData: Codable {
    var frenchTitle: String
    var englishTitle: String
    var frenchText: String
    var englishText: String
    var completionTimes: Int
    var minMoodLevel: Int
    var maxMoodLevel: Int
}

class ActivityImporter {
    // MARK: - Import JSON
    static func importFromJSON() -> [Activity] {
        let url = Bundle.main.url(forResource: "activities", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        let activities = try! decoder.decode([ActivityData].self, from: data)
        
        var activitiesToReturn = [Activity]()
        for activity in activities {
            activitiesToReturn.append(Activity(
                frenchTitle: activity.frenchTitle,
                englishTitle: activity.englishTitle,
                frenchText: activity.frenchText,
                englishText: activity.englishText,
                completionTimes: activity.completionTimes,
                minMoodLevel: activity.minMoodLevel,
                maxMoodLevel: activity.maxMoodLevel)
            )
        }
        
        return activitiesToReturn
    }
}
