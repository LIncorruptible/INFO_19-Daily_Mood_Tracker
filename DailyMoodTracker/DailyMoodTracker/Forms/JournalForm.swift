//
//  JournalForm.swift
//  DailyMoodTracker
//
//  Created by etudiant on 01/01/2025.
//

import SwiftUI
import SwiftData

struct JournalForm: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    var entry: Journal?
    @State private var selectedMood: Mood?
    @State private var date: Date = Date()
    @State private var notes: String = ""
    
    let moodController = MoodsController()

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Humeur")) {
                    Picker("Choisir une humeur", selection: $selectedMood) {
                        ForEach(moodController.fetchAllMoods(context: context), id: \.id) { mood in
                            Text(mood.name).tag(mood as Mood?)
                        }
                    }
                }

                Section(header: Text("Date")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }

                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 150)
                }
            }
            .navigationTitle(entry == nil ? "Nouvelle Entrée" : "Modifier Entrée")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sauvegarder") {
                        saveEntry()
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let entry = entry {
                    selectedMood = entry.mood
                    date = entry.date
                    notes = entry.notes
                }
            }
        }
    }

    private func saveEntry() {
        guard let mood = selectedMood else { return }

        if let entry = entry {
            entry.date = date
            entry.notes = notes
            entry.mood = mood
        } else {
            let newEntry = Journal(date: date, notes: notes, mood: mood, user: UserSession.shared.currentUser!)
            context.insert(newEntry)
        }

        do {
            try context.save()
        } catch {
            print("Erreur lors de la sauvegarde de l'entrée : \(error)")
        }
    }
}
