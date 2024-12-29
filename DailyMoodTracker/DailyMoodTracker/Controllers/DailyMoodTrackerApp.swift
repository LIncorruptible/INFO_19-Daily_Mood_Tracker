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
                .onAppear {
                    importQuotesIfNeeded()
                    importActivitiesIfNeeded()
                }
        }
        .modelContainer(sharedModelContainer)
    }

    private func importQuotesIfNeeded() {
        let context = sharedModelContainer.mainContext

        // Créez un FetchDescriptor pour le type Quote
        let fetchDescriptor = FetchDescriptor<Quote>()

        do {
            // On récupère le tableau d’objets de type Quote
            let quotes = try context.fetch(fetchDescriptor)

            if quotes.isEmpty {
                // S’il n’y en a aucun, on importe
                QuoteImporter.importQuotes(from: "citations", context: context)
            }

        } catch {
            print("Erreur lors de la récupération des citations : (error)")
        }
    }

    private func importActivitiesIfNeeded() {
        let context = sharedModelContainer.mainContext

        // Pareil pour Activity
        let fetchDescriptor = FetchDescriptor<Activity>()

        do {
            let activities = try context.fetch(fetchDescriptor)

            if activities.isEmpty {
                ActivityImporter.importActivities(from: "activities", context: context)
            }

        } catch {
            print("Erreur lors de la récupération des activités : (error)")
        }
    }
}
