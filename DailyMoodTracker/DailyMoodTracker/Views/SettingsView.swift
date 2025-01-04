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
                    
                    NavigationLink("Mon compte", destination: AccountView(localUser: userSession.currentUser!))
                    
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
    
    private func toggleTheme(_ isDarkMode: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
            }
        }
    }
    
    private func logout() {
        // Déconnexion de l'utilisateur
        userSession.logout()
        dismiss()
    }
}
