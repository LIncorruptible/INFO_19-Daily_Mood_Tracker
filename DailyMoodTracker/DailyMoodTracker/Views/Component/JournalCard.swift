//
//  JournalCard.swift
//  DailyMoodTracker
//
//  Created by etudiant on 04/01/2025.
//


import SwiftUI

struct JournalCard: View {
    let journal: Journal
    let onEdit: (Journal) -> Void
    let onDelete: (Journal) -> Void

    var body: some View {
        HStack(spacing: 16) {
            // Icône de l'humeur
            if let mood = journal.mood {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.1)) // Cercle coloré en arrière-plan
                        .frame(width: 50, height: 50)
                    
                    if let moodImage = mood.image {
                        Image(moodImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                    } else {
                        Image(systemName: "questionmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.gray)
                    }
                    
                    // Son nom
                    Text(mood.name)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .padding(4)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Capsule())
                        .offset(x: 0, y: 20)
                }
            }

            // Informations principales
            VStack(alignment: .leading, spacing: 8) {
                Text(journal.date, style: .date)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(journal.notes)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .contextMenu {
            Button {
                onEdit(journal)
            } label: {
                Label("Modifier", systemImage: "pencil")
            }

            Button(role: .destructive) {
                onDelete(journal)
            } label: {
                Label("Supprimer", systemImage: "trash")
            }
        }
    }
}
