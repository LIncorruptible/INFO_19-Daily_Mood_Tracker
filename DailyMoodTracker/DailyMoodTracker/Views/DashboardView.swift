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
    @State private var currentMood: Mood?
    @State private var suggestedActivities: [Activity] = []
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            
            NavigationStack {
                VStack(alignment: .leading, spacing: 20) {
                    // Section bienvenue
                    HStack {
                        Text("👋 Bienvenue, \(userSession.currentUser?.username ?? "Utilisateur")!")
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                    }
                    .padding([.top, .horizontal])
                    
                    // Section Humeur actuelle
                    moodSection()
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // Section Citation du jour
                    quoteSection()
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // Section défilante pour les suggestions d’activités
                    Text("💡 Suggestions d’activités")
                        .font(.headline)
                        .bold()
                        .padding(.horizontal)
                    
                    ScrollView {
                        activitySuggestions()
                            .padding(.horizontal)
                    }
                    .frame(maxHeight: .infinity)
                    
                    Spacer()
                    
                    // Barre de navigation en bas
                    bottomNavigationBar()
                        .padding(.horizontal)
                }
            }
            .onAppear {
                getDailyQuote()
                getActivities()
            }
        }
    }
    
    // Section Humeur actuelle
    @ViewBuilder
    private func moodSection() -> some View {
        if let mood = currentMood {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Humeur actuelle")
                        .font(.headline)
                        .bold()
                    
                    Spacer()
                    
                    if let moodImage = mood.image {
                        Image(moodImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                }
                
                Text(mood.name)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.primary)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding()
            .background(Color.blue.opacity(0.05))
            .cornerRadius(10)
        } else {
            Text("Aucune humeur actuelle définie.")
                .font(.headline)
                .padding(.top, 10)
        }
    }

    // Section Citation du jour
    @ViewBuilder
    private func quoteSection() -> some View {
        if let quote = quoteOfTheDay {
            VStack(alignment: .leading, spacing: 10) {
                Text("📜 Citation du jour")
                    .font(.headline)
                    .bold()
                
                Text("« \(quote.frenchText) »")
                    .italic()
                    .font(.body)
                    .padding(.vertical, 4)
                
                Text("- \(quote.author)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            .background(Color.green.opacity(0.05))
            .cornerRadius(10)
        } else {
            Text("Aucune citation disponible pour le moment.")
                .font(.headline)
                .padding(.top, 10)
        }
    }

    // Section Suggestions d’activités
    @ViewBuilder
    private func activitySuggestions() -> some View {
        if !suggestedActivities.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(suggestedActivities, id: \.id) { activity in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(activity.frenchTitle)
                            .font(.subheadline)
                            .bold()
                        
                        Text(activity.frenchText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.05))
                    .cornerRadius(10)
                }
            }
        } else {
            Text("Aucune activité suggérée pour l’humeur actuelle.")
                .font(.subheadline)
                .padding(.vertical)
        }
    }
    
    private func bottomNavigationBar() -> some View {
        HStack(spacing: 20) {
            Spacer() // Ajout d'un Spacer à gauche
            
            NavigationLink(destination: MoodsView()) {
                VStack {
                    Image(systemName: "face.smiling")
                        .font(.title2)
                    Text("Humeurs")
                        .font(.caption)
                }
            }
            
            NavigationLink(destination: JournalsView()) {
                VStack {
                    Image(systemName: "book.closed")
                        .font(.title2)
                    Text("Journal")
                        .font(.caption)
                }
            }
            
            Spacer() // Ajout d'un Spacer à droite
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func getDailyQuote() {
        if Calendar.current.isDateInToday(userSession.lastQuoteDateChanged) {
            if let currentQuoteUUID = userSession.currentQuoteUUID {
                quoteOfTheDay = quotes.first { $0.id == currentQuoteUUID }
            } else {
                quoteOfTheDay = quotes.randomElement()
                userSession.updateQuote(quoteUUID: quoteOfTheDay?.id ?? UUID())
            }
        } else {
            quoteOfTheDay = quotes.randomElement()
            userSession.updateQuote(quoteUUID: quoteOfTheDay?.id ?? UUID())
        }
    }
    
    private func getActivities() {
        if let currentUser = userSession.currentUser {
            if let latestJournal = try? JournalController(context: context).getLatestByUser(byUser: currentUser) {
                currentMood = latestJournal.mood
                
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
