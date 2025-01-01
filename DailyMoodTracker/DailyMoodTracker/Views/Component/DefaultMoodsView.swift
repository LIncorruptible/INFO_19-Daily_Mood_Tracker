//
//  DefaultMoodsView.swift
//  DailyMoodTracker
//
//  Created by etudiant on 30/12/2024.
//

import SwiftUI

struct DefaultMoodsView: View {
    let moods: [Mood]

    var body: some View {
        VStack {
            Text("Humeurs de base")
                .font(.headline)
                .padding(.bottom, 16)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    // Première ligne
                    HStack(spacing: 16) {
                        ForEach(moods[0..<3], id: \.id) { mood in
                            moodCard(mood)
                        }
                    }
                    // Deuxième ligne
                    HStack(spacing: 16) {
                        ForEach(moods[3..<5], id: \.id) { mood in
                            moodCard(mood)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
        }
    }

    private func moodCard(_ mood: Mood) -> some View {
        VStack(spacing: 4) {
            if let imageName = mood.image, !imageName.isEmpty {
                Image(imageName)
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
            Text(mood.name)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
}
