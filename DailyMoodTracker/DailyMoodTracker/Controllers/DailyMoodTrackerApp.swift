//
//  DailyMoodTrackerApp.swift
//  DailyMoodTracker
//
//  Created by etudiant on 10/12/2024.
//

import SwiftUI
import SwiftData

@main
struct DailyMoodTrackerApp: App {

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Mood.self,
            Journal.self,
            Quote.self,
            Activity.self
        ])
        return try! ModelContainer(for: schema)
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .onAppear {
            importQuotesIfNeeded()
            importActivitiesIfNeeded()
        }
    }

    private func importQuotesIfNeeded() {
        let context = sharedModelContainer.mainContext
        if context.fetch(Quote.self).isEmpty {
            QuoteImporter.importQuotes(from: "citations", context: context)
        }
    }

    private func importActivitiesIfNeeded() {
        let context = sharedModelContainer.mainContext
        if context.fetch(Activity.self).isEmpty {
            ActivityImporter.importActivities(from: "activities", context: context)
        }
    }
}
