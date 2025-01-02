//
//  UserSession.swift
//  DailyMoodTracker
//
//  Created by etudiant on 29/12/2024.
//

import Foundation
import SwiftData
import SwiftUI

class UserSession: ObservableObject {
    static let shared = UserSession() // Singleton partagé

    @Published var currentUser: User? {
        didSet {
            saveUserToDefaults()
        }
    }

    @Published var isLoggedIn: Bool = false // Nouvel état global pour la connexion
    @Published var lastQuoteDateChanged: Date = Date() // Date de la dernière modification de la citation
    @Published var currentQuoteUUID: UUID? // UUID de la citation actuelle

    @Environment(\.modelContext) private var context: ModelContext // Contexte SwiftData

    private init() {
        loadUserFromDefaults()
        isLoggedIn = currentUser != nil // Détermine si un utilisateur est connecté
    }

    func login(user: User) {
        currentUser = user
        isLoggedIn = true
    }

    func logout() {
        currentUser = nil
        isLoggedIn = false
        currentQuoteUUID = nil
        lastQuoteDateChanged = Date()
    }

    // Met à jour la citation du jour
    func updateQuote(quoteUUID: UUID) {
        currentQuoteUUID = quoteUUID
        lastQuoteDateChanged = Date()
        saveUserToDefaults() // Sauvegarder après mise à jour
    }

    // Sauvegarder l'utilisateur et les informations sur la citation dans UserDefaults
    private func saveUserToDefaults() {
        guard let user = currentUser else {
            UserDefaults.standard.removeObject(forKey: "loggedInUser")
            UserDefaults.standard.removeObject(forKey: "lastQuoteDateChanged")
            UserDefaults.standard.removeObject(forKey: "currentQuoteUUID")
            return
        }

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            UserDefaults.standard.set(data, forKey: "loggedInUser")
            UserDefaults.standard.set(lastQuoteDateChanged, forKey: "lastQuoteDateChanged")
            if let uuid = currentQuoteUUID {
                UserDefaults.standard.set(uuid.uuidString, forKey: "currentQuoteUUID")
            }
        } catch {
            print("Erreur lors de la sauvegarde des données utilisateur : \(error)")
        }
    }

    // Charger l'utilisateur et les informations sur la citation depuis UserDefaults
    private func loadUserFromDefaults() {
        guard let data = UserDefaults.standard.data(forKey: "loggedInUser") else {
            return
        }

        do {
            let decoder = JSONDecoder()
            currentUser = try decoder.decode(User.self, from: data)
            lastQuoteDateChanged = UserDefaults.standard.object(forKey: "lastQuoteDateChanged") as? Date ?? Date()
            if let uuidString = UserDefaults.standard.string(forKey: "currentQuoteUUID") {
                currentQuoteUUID = UUID(uuidString: uuidString)
            }
        } catch {
            print("Erreur lors du chargement des données utilisateur : \(error)")
        }
    }
}
