//
//  CustomMoodCard.swift
//  DailyMoodTracker
//
//  Created by etudiant on 06/01/2025.
//

import SwiftUI

struct CustomMoodCard: View {
    let mood: Mood
    let onEdit: (Mood) -> Void
    let onDelete: (Mood) -> Void

    var body: some View {
        HStack(spacing: 16) {
            // On vérifie d’abord userImageData
            if let userImageData = mood.userImageData,
               let uiImage = UIImage(data: userImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)

            } else if let moodImage = mood.image,
                      !moodImage.isEmpty {
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

            VStack(alignment: .leading, spacing: 4) {
                Text(mood.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                if !mood.text.isEmpty {
                    Text(mood.text)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .contextMenu {
            Button {
                onEdit(mood)
            } label: {
                Label("Modifier", systemImage: "pencil")
            }

            Button(role: .destructive) {
                onDelete(mood)
            } label: {
                Label("Supprimer", systemImage: "trash")
            }
        }
    }
}
