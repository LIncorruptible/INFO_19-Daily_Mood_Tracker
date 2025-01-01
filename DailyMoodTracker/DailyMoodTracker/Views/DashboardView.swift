//
//  DashboardView.swift
//  DailyMoodTracker
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query var moods: [Mood]
    @Query var quotes: [Quote]
    @Query var activities: [Activity]
    
    @ObservedObject private var userSession = UserSession.shared
    @Environment(\.dismiss) private var dismiss
    @State private var randomQuote: Quote?
    
    var body: some View {
        NavigationStack {
            VStack {
                // Nom d'utilisateur en haut de la vue
                HStack {
                    Text("Bienvenue, \(userSession.currentUser?.username ?? "Utilisateur")!")
                        .font(.title2)
                        .bold()
                        .padding(.leading)
                    
                    Spacer()
                }
                .padding(.top)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // MARK: - Citation aléatoire
                        if let quote = randomQuote {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Citation du jour")
                                    .font(.headline)
                                
                                Text("« \(quote.frenchText) »")
                                    .italic()
                                    .font(.body)
                                
                                Text("- \(quote.author)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.top, 10)
                        } else {
                            Text("Aucune citation disponible pour le moment.")
                                .font(.headline)
                                .padding(.top, 10)
                        }
                        
                        Divider()
                        
                        // MARK: - Suggestions d’activités
                        if let lastMood = moods.last {
                            let suggestedActivities = activities.filter {
                                $0.minMoodLevel <= lastMood.level && lastMood.level <= $0.maxMoodLevel
                            }
                            
                            if !suggestedActivities.isEmpty {
                                Text("Suggestions d’activités :")
                                    .font(.headline)
                                
                                ForEach(suggestedActivities, id: \.id) { activity in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(activity.frenchTitle)
                                            .font(.subheadline)
                                            .bold()
                                        Text(activity.frenchText)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.vertical, 4)
                                }
                            } else {
                                Text("Aucune activité suggérée pour l’humeur actuelle.")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                // MARK: - Barre de navigation en bas
                HStack(spacing: 20) {
                    NavigationLink("Humeurs") {
                        MoodsView()
                    }
                    NavigationLink("Journal") {
                        JournalsView() // Utilisation de la vue du journal
                    }
                    NavigationLink("Paramètres") {
                        //SettingsView() // Redirige vers une vue des paramètres
                    }
                }
                .padding()
            }
            .navigationTitle("Tableau de bord")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        userSession.logout()
                        dismiss()
                    }) {
                        Text("Déconnexion")
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                randomQuote = quotes.randomElement()
            }
        }
    }
}
