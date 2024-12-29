import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query var moods: [Mood]
    @Query var quotes: [Quote]
    @Query var activities: [Activity]
    
    @State private var randomQuote: Quote?
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // MARK: - Dernière humeur
                        if let lastMood = moods.last {
                            Text("Dernière humeur : \(lastMood.name)")
                                .font(.headline)
                            
                            Image(lastMood.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .padding(.bottom, 5)
                            
                            Text("Niveau : \(lastMood.level)")
                                .font(.subheadline)
                            Text(lastMood.text)
                                .font(.body)
                        } else {
                            Text("Aucune humeur enregistrée.")
                                .font(.headline)
                        }
                        
                        Divider()
                        
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
                
                // Force la barre de navigation en bas
                Spacer()
                
                // MARK: - Barre de navigation en bas
                HStack(spacing: 20) {
                    NavigationLink("Humeurs") {
                        Text("Page Humeurs à implémenter")
                            .font(.title2)
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
            .onAppear {
                randomQuote = quotes.randomElement()
            }
        }
    }
}
