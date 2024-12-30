//
//  UserSession.swift
//  DailyMoodTracker
//
//  Created by etudiant on 29/12/2024.
//

import Foundation

class UserSession: ObservableObject {
    static let shared = UserSession() // Singleton partagé

    @Published var currentUser: User? {
        didSet {
            saveUserToDefaults()
        }
    }

    @Published var isLoggedIn: Bool = false // Nouvel état global pour la connexion

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
    }

    // Sauvegarder l'utilisateur connecté dans UserDefaults
    private func saveUserToDefaults() {
        guard let user = currentUser else {
            UserDefaults.standard.removeObject(forKey: "loggedInUser")
            return
        }

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            UserDefaults.standard.set(data, forKey: "loggedInUser")
        } catch {
            print("Erreur lors de la sauvegarde de l'utilisateur : \(error)")
        }
    }

    // Charger l'utilisateur connecté depuis UserDefaults
    private func loadUserFromDefaults() {
        guard let data = UserDefaults.standard.data(forKey: "loggedInUser") else {
            currentUser = nil
            return
        }

        do {
            let decoder = JSONDecoder()
            currentUser = try decoder.decode(User.self, from: data)
        } catch {
            print("Erreur lors du chargement de l'utilisateur : \(error)")
        }
    }
}
