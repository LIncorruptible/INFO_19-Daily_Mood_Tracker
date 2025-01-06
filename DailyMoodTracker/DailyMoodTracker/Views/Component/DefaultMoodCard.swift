//
//  MoodCard.swift
//  DailyMoodTracker
//
//  Created by etudiant on 06/01/2025.
//

import SwiftUI

struct DefaultMoodCard: View {
    let mood: Mood

    var body: some View {
        VStack(spacing: 8) {
            // Image de l'humeur
            if let moodImage = mood.image {
                Image(moodImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            } else {
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }

            // Nom de l'humeur
            Text(mood.name)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center) // Centre le texte sur plusieurs lignes
                .minimumScaleFactor(0.7) // Réduit la taille si le texte est trop long
                .frame(maxWidth: .infinity) // S'assure que le texte prend la largeur disponible
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
