//
//  JournalsList.swift
//  DailyMoodTracker
//
//  Created by etudiant on 03/01/2025.
//

import SwiftUI
import SwiftData

struct JournalsList: View {
    let journals: [Journal]
    let onEdit: (Journal) -> Void
    let onDelete: (Journal) -> Void

    var body: some View {
        // Trier les journaux par date dans l'ordre décroissant
        let sortedJournals = journals.sorted { $0.date > $1.date }
        
        List(sortedJournals, id: \.id) { journal in
            HStack {
                VStack(alignment: .leading) {
                    Text(journal.date, style: .date)
                    Text(journal.notes).font(.subheadline)
                }
                
                Spacer() // Pousse l'image et le texte à droite

                if let mood = journal.mood {
                    VStack {
                        // Image de l'humeur
                        if let moodImage = mood.image {
                            Image(moodImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24) // Taille ajustée
                        } else {
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.gray)
                        }

                        // Nom de l'humeur
                        Text(mood.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(alignment: .trailing) // Aligne l'ensemble à droite
                }
            }
            .padding(.vertical, 4)
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
}
