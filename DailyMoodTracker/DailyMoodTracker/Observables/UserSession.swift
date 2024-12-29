//
//  UserSession.swift
//  DailyMoodTracker
//
//  Created by etudiant on 29/12/2024.
//

import Foundation

class UserSession: ObservableObject {
    static let shared = UserSession() // Singleton partagé

    @Published var currentUser: User? // Utilisateur connecté

    private init() {}

    // Méthode pour connecter un utilisateur
    func login(user: User) {
        currentUser = user
    }

    // Méthode pour déconnecter l'utilisateur
    func logout() {
        currentUser = nil
    }

    // Vérifie si un utilisateur est connecté
    var isLoggedIn: Bool {
        currentUser != nil
    }
}
