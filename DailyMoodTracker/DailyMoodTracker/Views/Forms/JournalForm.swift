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

    @Binding var mode: JournalFormMode
    @Binding var date: Date
    @Binding var notes: String
    @Binding var mood: Mood?
    @State private var selectedMood: Mood?
    
    @Environment(\.modelContext) private var context: ModelContext
    
    private var controller: MoodController
    @State private var moods: [Mood] = []
    
    // Gestion des erreurs
    @State private var nameError: String? = nil
    @State private var descriptionError: String? = nil
    
    let onSave: () -> Void
    
    // Constructeur public
    public init(
        mode: Binding<JournalFormMode>,
        date: Binding<Date>,
        notes: Binding<String>,
        mood: Binding<Mood?>,
        controller: MoodController,
        onSave: @escaping () -> Void
    ) {
        self._mode = mode
        self._date = date
        self._notes = notes
        self._mood = mood
        self.controller = controller
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Informations") {
                    DatePicker("Date", selection: $date, displayedComponents: [.date])
                    
                    TextField("Notes", text: $notes)
                        .onChange(of: notes) { newValue in
                            if newValue.count > 255 {
                                notes = String(newValue.prefix(255))
                                descriptionError = "Les notes ne peuvent pas dépasser 255 caractères."
                            } else {
                                descriptionError = nil
                            }
                        }
                    if let descriptionError = descriptionError {
                        Text(descriptionError)
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                    
                    Picker("Humeur", selection: $selectedMood) {
                        ForEach(moods, id: \.id) { mood in
                            Text(mood.name).tag(mood as Mood?) // Associe chaque humeur comme un tag
                        }
                    }
                    .onChange(of: selectedMood) { newValue in
                        mood = newValue!
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        if validateForm() {
                            onSave()
                            dismiss()
                        }
                    }
                }
            }
            .onAppear {
                fetchMoods()
                selectedMood = mood ?? moods.randomElement()
            }
        }
    }
    
    private var title: String {
        switch mode {
            case .add: return "Nouveau journal"
            case .edit: return "Modifier le journal"
        }
    }

    // MARK: - Validation du formulaire
    private func validateForm() -> Bool {
        var isValid = true
        
        if notes.isEmpty {
            descriptionError = "Les notes ne peuvent pas être vides."
            isValid = false
        }
        
        if date > Date() {
            descriptionError = "La date ne peut pas être dans le futur."
            isValid = false
        }
        
        if selectedMood == nil {
            descriptionError = "Veuillez sélectionner une humeur."
            isValid = false
        }
        
        return isValid
    }
    
    
    // MARK: - Gestion des erreurs
    private func handleError(_ error: Error) {
        print("Une erreur est survenue : \(error.localizedDescription)")
    }
        
    // MARK: - Chargement des humeurs
    private func fetchMoods() {
        do {
            moods = try controller.getAll()
        } catch {
            handleError(error)
        }
    }
}
