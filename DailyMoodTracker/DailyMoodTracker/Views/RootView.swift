//
//  RootView.swift
//  DailyMoodTracker
//
//  Created by etudiant on 01/01/2025.
//


import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var context: ModelContext
    @ObservedObject private var userSession = UserSession.shared

    var body: some View {
        Group {
            if userSession.isLoggedIn {
                DashboardView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            initializeData()
        }
    }

    // MARK: - Initial
    private func initializeData() {
        do {
            try importQuotesIfNeeded()
            try importActivitiesIfNeeded()
            try importUsersIfNeeded()
        } catch {
            print("Erreur lors de l'initialisation des données de l'application : \(error)")
        }
    }

    // MARK: - Import
    private func importQuotesIfNeeded() throws {
        let quoteController = QuoteController(context: context)
        let quotes = try quoteController.getAll()
        if quotes.isEmpty {
            try quoteController.createMany(quotes: QuoteImporter.importFromJSON())
            print("Citations importées avec succès")
        }
    }

    private func importActivitiesIfNeeded() throws {
        let activityController = ActivityController(context: context)
        let activities = try activityController.getAll()
        if activities.isEmpty {
            try activityController.createMany(activities: ActivityImporter.importFromJSON())
            print("Activités importées avec succès")
        }
    }
    
    private func importUsersIfNeeded() throws {
        let userController = UserController(context: context)
        let users = try userController.getAll()
        if users.isEmpty {
            try userController.createMany(users: UserImporter.importFromJSON())
            print("Utilisateurs importés avec succès")
        }
    }
}
