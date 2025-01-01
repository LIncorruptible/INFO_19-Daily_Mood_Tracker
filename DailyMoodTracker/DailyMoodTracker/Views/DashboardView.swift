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
                        // -- Section Dernière humeur supprimée --

                        // MARK: - Citation aléatoire
                        if let quote = randomQuote {
                            Text("Citation du jour")
                                .font(.headline)
                            
                            Text(quote.title)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("« \(quote.frenchText) »")
                                .italic()
                                .font(.body)
                            
                            Text("- \(quote.author)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                        } else {
                            Text("Aucune citation disponible pour le moment.")
                                .font(.headline)
                                .padding(.top, 10)
                        }
                        
                        Divider()
                        
                        // MARK: - Suggestions d’activités
                        // (facultatif) si tu veux les conserver, tu peux les laisser
                        // ou commenter si tu ne veux plus de suggestions
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
                } // Fin du ScrollView
                
                Spacer()
                
                // MARK: - Barre de navigation en bas
                HStack(spacing: 20) {
                    NavigationLink("Humeurs") {
                        MoodsView()
                    }
                    NavigationLink("Journal") {
                        Text("Page Journal à implémenter")
                            .font(.title2)
                    }
                    NavigationLink("Paramètres") {
                        Text("Page Paramètres à implémenter")
                            .font(.title2)
                    }
                }
                .padding()
            } // Fin du VStack
            .navigationTitle("Tableau de bord")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        userSession.logout()
                    }) {
                        Text("Déconnexion")
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                // On pioche la citation de manière aléatoire
                randomQuote = quotes.randomElement()
            }
        }
    }
}
