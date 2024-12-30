//
//  EditMoodForm.swift
//  DailyMoodTracker
//
//  Created by etudiant on 30/12/2024.
//


import SwiftUI
import SwiftData

struct EditMoodForm: View {
    @Environment(\.dismiss) private var dismiss
    
    // L’humeur à modifier
    @State var mood: Mood
    
    // Champs d’édition
    @State private var editedName: String = ""
    @State private var editedDescription: String = ""
    @State private var editedLevel: Int16 = 5
    
    var body: some View {
        NavigationView {
            Form {
                Section("Modifier l'humeur") {
                    TextField("Nom", text: $editedName)
                    TextField("Description", text: $editedDescription)
                    
                    Stepper(value: $editedLevel, in: 0...10) {
                        Text("Niveau : \(editedLevel)")
                    }
                }
            }
            .navigationTitle("Éditer l’humeur")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        saveChanges()
                        dismiss()
                    }
                }
            }
            .onAppear {
                // Initialise les champs avec la valeur actuelle
                editedName = mood.name
                editedDescription = mood.text
                editedLevel = mood.level
            }
        }
    }
    
    private func saveChanges() {
        // Applique les modifications
        mood.name = editedName
        mood.text = editedDescription
        mood.level = editedLevel
        
        // Sauvegarde en base
        if let context = mood.modelContext {
            do {
                try context.save()
                print("Humeur mise à jour avec succès.")
            } catch {
                print("Erreur lors de la sauvegarde : \(error)")
            }
        }
    }
}