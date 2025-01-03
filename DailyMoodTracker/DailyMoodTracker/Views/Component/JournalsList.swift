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
        List(journals, id: \.id) { journal in
            VStack(alignment: .leading) {
                Text(journal.date, style: .date)
                Text(journal.notes).font(.subheadline)
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
