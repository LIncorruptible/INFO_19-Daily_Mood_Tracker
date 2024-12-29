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
            DashboardView()  // <-- On affiche DashboardView en premier
                .onAppear {
                    importQuotesIfNeeded()
                    importActivitiesIfNeeded()
                }
        }
        .modelContainer(sharedModelContainer)
    }

    private func importQuotesIfNeeded() {
        let context = sharedModelContainer.mainContext
        
        let fetchDescriptor = FetchDescriptor<Quote>()
        do {
            let quotes = try context.fetch(fetchDescriptor)
            if quotes.isEmpty {
                QuoteImporter.importQuotes(from: "citations", context: context)
            }
        } catch {
            print("Erreur lors de la récupération des citations : \(error)")
        }
    }

    private func importActivitiesIfNeeded() {
        let context = sharedModelContainer.mainContext
        
        let fetchDescriptor = FetchDescriptor<Activity>()
        do {
            let activities = try context.fetch(fetchDescriptor)
            if activities.isEmpty {
                ActivityImporter.importActivities(from: "activities", context: context)
            }
        } catch {
            print("Erreur lors de la récupération des activités : \(error)")
        }
    }
}
