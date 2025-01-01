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
    @Environment(\.modelContext) private var context: ModelContext
    
    @State private var quoteOfTheDay: Quote?
    @State private var currentMood: Mood? // Variable pour l'humeur actuelle
    @State private var suggestedActivities: [Activity] = [] // Activités suggérées
    
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
                        // MARK: - Humeur actuelle
                        if let mood = currentMood {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Humeur actuelle")
                                    .font(.headline)
                                
                                Text(mood.name) // Affiche uniquement le nom de l'humeur
                                    .font(.subheadline)
                                    .bold()
                            }
                            .padding(.top, 10)
                        } else {
                            Text("Aucune humeur actuelle définie.")
                                .font(.headline)
                                .padding(.top, 10)
                        }
                        
                        Divider()
                        
                        // MARK: - Citation aléatoire
                        if let quote = quoteOfTheDay {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Citation du jour")
                                    .font(.headline)
                                
                                Text("« \(quote.frenchText) »") // Utilise la version française
                                    .italic()
                                    .font(.body)
                                
                                Text("- \(quote.author)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .padding(.top, 10)
                        } else {
                            Text("Aucune citation disponible pour le moment.")
                                .font(.headline)
                                .padding(.top, 10)
                        }
                        
                        Divider()
                        
                        // MARK: - Suggestions d’activités
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
                    .padding()
                }
                
                Spacer()
                
                // MARK: - Barre de navigation en bas
                HStack(spacing: 20) {
                    NavigationLink("Humeurs") {
                        MoodsView() // Redirige vers la vue des humeurs
                    }
                    NavigationLink("Journal") {
                        // JournalsView() // Utilisation de la vue du journal
                    }
                    NavigationLink("Paramètres") {
                        // SettingsView() // Redirige vers une vue des paramètres
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
                // Récupération de la citation
                quoteOfTheDay = try? QuoteController(context: context).getRandom()
                
                // Récupération de l'humeur actuelle
                if let currentUser = userSession.currentUser {
                    if let latestJournal = try? JournalController(context: context).getLatestByUser(byUser: currentUser) {
                        currentMood = latestJournal.mood
                        
                        // Suggestions d'activités basées sur l'humeur
                        if let mood = currentMood {
                            do {
                                let activityController = ActivityController(context: context)
                                suggestedActivities = try activityController.getManyRandomly(
                                    howMany: 5,
                                    minLevel: mood.level,
                                    maxLevel: mood.level
                                )
                            } catch {
                                print("Erreur lors de la récupération des activités : \(error.localizedDescription)")
                                suggestedActivities = []
                            }
                        }
                    } else {
                        currentMood = nil
                        suggestedActivities = []
                    }
                }
            }
        }
    }
}
