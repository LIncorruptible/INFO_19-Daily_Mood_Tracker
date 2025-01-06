//
//  CustomMoodsList.swift
//  DailyMoodTracker
//
//  Created by etudiant on 06/01/2025.
//

import SwiftUI

struct CustomMoodsList: View {
    let moods: [Mood]
    let onEdit: (Mood) -> Void
    let onDelete: (Mood) -> Void

    var body: some View {
        List {
            ForEach(moods, id: \.id) { mood in
                CustomMoodCard(
                    mood: mood,
                    onEdit: onEdit,
                    onDelete: onDelete
                )
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowSeparator(.hidden) // Supprime les séparateurs entre les cartes
            }
        }
        .listStyle(PlainListStyle()) // Style iOS natif
    }
}
