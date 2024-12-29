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
            LoginView()
                .modelContainer(sharedModelContainer)
                .onAppear {
                    printAllUsers()
                }
        }
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
}
