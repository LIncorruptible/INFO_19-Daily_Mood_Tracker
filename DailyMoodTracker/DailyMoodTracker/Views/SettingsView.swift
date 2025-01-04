//
//  SettingsView.swift
//  DailyMoodTracker
//
//  Created by etudiant on 04/01/2025.
//


import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "Français"
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @ObservedObject private var userSession = UserSession.shared
    
    let languages = ["Français", "English", "Español", "Deutsch"]

    var body: some View {
        NavigationStack {
            Form {
                // Section : Compte
                Section(header: Text("Compte")) {
                    Button(action: editAccount) {
                        Label("Éditer mon compte", systemImage: "person.crop.circle")
                    }
                    Button(action: logout) {
                        Label("Se déconnecter", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }

                // Section : Apparence
                Section(header: Text("Apparence")) {
                    Toggle(isOn: $isDarkMode) {
                        Label("Thème sombre", systemImage: isDarkMode ? "moon.fill" : "sun.max.fill")
                    }
                    .onChange(of: isDarkMode) { value in
                        toggleTheme(value)
                    }
                }

                // Section : Langue
                Section(header: Text("Langue")) {
                    Picker("Changer la langue", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(language)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            .navigationTitle("Paramètres")
        }
    }
    
    // Actions
    
    private func editAccount() {
        // Action pour éditer le compte
        print("Éditer le compte")
    }
    
    private func toggleTheme(_ isDarkMode: Bool) {
        // Action pour changer le thème de l'application
        print("Thème sombre activé : \(isDarkMode)")
    }
    
    private func logout() {
        // Déconnexion de l'utilisateur
        userSession.logout()
        dismiss()
    }
}
