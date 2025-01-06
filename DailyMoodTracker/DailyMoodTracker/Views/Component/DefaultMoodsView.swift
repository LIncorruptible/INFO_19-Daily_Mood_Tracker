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
        VStack(alignment: .leading, spacing: 16) {
//            Text("Humeurs de base")
//                .font(.headline)
//                .padding(.horizontal)
//                .padding(.top)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(moods, id: \.id) { mood in
                    DefaultMoodCard(mood: mood)
                }
            }
            .padding(.horizontal)
        }
    }
}
