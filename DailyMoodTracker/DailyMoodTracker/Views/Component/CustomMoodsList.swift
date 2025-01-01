//
//  CustomMoodsList.swift
//  DailyMoodTracker
//
//  Created by etudiant on 30/12/2024.
//


import SwiftUI

struct CustomMoodsList: View {
    let moods: [Mood]
    let onEdit: (Mood) -> Void
    let onDelete: (Mood) -> Void

    var body: some View {
        List {
            ForEach(moods, id: \.id) { mood in
                HStack {
                    // Image de l'humeur
                    if let data = mood.userImageData,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    } else {
                        Image(systemName: "questionmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.gray)
                    }

                    // Nom et description
                    VStack(alignment: .leading) {
                        Text("\(mood.name) (Niveau: \(mood.level))")
                            .font(.body)
                        if !mood.text.isEmpty {
                            Text(mood.text)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()
                }
                .padding(.vertical, 4)
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
        .listStyle(.inset)
    }
}