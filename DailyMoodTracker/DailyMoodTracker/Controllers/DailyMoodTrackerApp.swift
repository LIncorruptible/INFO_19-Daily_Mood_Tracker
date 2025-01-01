import SwiftUI
import SwiftData

@main
struct DailyMoodTrackerApp: App {
    @ObservedObject private var userSession = UserSession.shared

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
            if userSession.isLoggedIn {
                DashboardView() // Redirige vers DashboardView si l'utilisateur est connecté
                .onAppear {
                    importQuotesIfNeeded()
                    importActivitiesIfNeeded()
                    printAllMoods()
                }
            } else {
                LoginView() // Sinon, redirige vers LoginView
                    .onAppear {
                        printAllUsers()
                    }
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
    
    // MARK: - Fonctions débogage BDD
    
    func printDatabaseLocation() {
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        if let appSupportPath = paths.first {
            print("Le fichier de la base de données se trouve ici : \(appSupportPath.path)")
        }
    }
    
    private func printAllUsers() {
        print("Liste des utilisateurs :")
        let userController = UserController()
        do {
            let users = try userController.getAllUsers(context: sharedModelContainer.mainContext)
            for user in users {
                print(user.email, " - ",  user.dateCreated, " - " + user.password)
            }
        } catch {
            print("Erreur lors de la récupération de tous les utilisateurs : \(error.localizedDescription)")
        }
    }
    
    private func deleteAllUsers() {
        print("Suppression de tous les utilisateurs...")
        let userController = UserController()
        do {
            try userController.deleteAllUsers(context: sharedModelContainer.mainContext)
        } catch {
            print("Erreur lors de la suppression de tous les utilisateurs : \(error.localizedDescription)")
        }
    }
    
    private func printAllMoods() {
        print("Liste des humeurs :")
        let moodController = MoodsController()
        let moods = moodController.fetchAllMoods(context: sharedModelContainer.mainContext)
        for mood in moods {
            print(mood.name, " - ", mood.level, " - ", mood.text)
        }
    }
}
