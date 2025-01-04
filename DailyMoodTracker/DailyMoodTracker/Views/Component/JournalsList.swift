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
        
        ScrollView {
            VStack(spacing: 16) {
                ForEach(sortedJournals, id: \.id) { journal in
                    JournalCard(
                        journal: journal,
                        onEdit: onEdit,
                        onDelete: onDelete
                    )
                }
            }
            .padding()
        }
    }
}
