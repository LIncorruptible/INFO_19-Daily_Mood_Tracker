//
//  JournalsView.swift
//  DailyMoodTracker
//
//  Created by etudiant on 01/01/2025.
//

import SwiftUI
import SwiftData

enum JournalFormMode {
    case add
    case edit(Journal)
}

struct JournalsView: View {

    // MARK: - Journaux
    @State private var journals: [Journal] = []
    @Environment(\.modelContext) private var context: ModelContext
    @State private var controller: JournalController?
    @ObservedObject private var userSession = UserSession.shared
    
    // Mark: - Formulaire d'ajout/modification
    @State private var showForm: Bool = false
    @State private var formMode: JournalFormMode = .add
    
    // Champs du formulaire
    @State private var formDate: Date = Date()
    @State private var formNotes: String = ""
    @State private var formMood: Mood? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                if journals.isEmpty {
                    Text("Aucun journal pour le moment.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    JournalsList(
                        journals: journals,
                        onEdit: { journal in setupEditForm(with: journal) },
                        onDelete: { journal in
                            do {
                                try controller!.deleteById(byId: journal.id)
                                fetchJournals()
                            } catch {
                                handleError(error)
                            }
                        }
                    )
                }
                
                // Bouton pour ajouter un journal
                Button {
                    setupAddForm()
                } label: {
                    Image(systemName: "plus")
                    Text("Ajouter un journal")
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                .padding(.vertical, 8)
                
                Spacer()
            }
            .navigationTitle("Journaux")
            .onAppear {
                controller = JournalController(context: context)
                fetchJournals()
            }
            .sheet(isPresented: $showForm) {
                JournalForm(
                    mode: formMode,
                    date: $formDate,
                    notes: $formNotes,
                    mood: $formMood,
                    controller: MoodController(context: context)
                ) {
                    performSave()
                }
            }
        }
    }
    
    // MARK: - Prépare le formulaire pour l'ajout
    private func setupAddForm() {
        formMode = .add
        formDate = Date()
        formNotes = ""
        formMood = nil
        showForm.toggle()
    }
    
    // MARK: - Prépare le formulaire pour l'édition
    private func setupEditForm(with journal: Journal) {
        formMode = .edit(journal)
        formDate = journal.date
        formNotes = journal.notes
        formMood = journal.mood
        showForm.toggle()
    }
    
    // MARK: - Enregistre les données selon le mode
    private func performSave() {
        do {
            
            let userController = UserController(context: context)
            let user = try userController.getById(byId: userSession.currentUser!.id)
            
            if case .add = formMode {
                let journalToCreate: Journal = Journal(
                    date: formDate,
                    notes: formNotes,
                    mood: formMood!,
                    user: user!
                )
                try controller!.create(journal: journalToCreate)
            } else {
                let journalToUpdate: Journal = Journal(
                    id: journals.first!.id,
                    date: formDate,
                    notes: formNotes,
                    mood: formMood!,
                    user: user!
                )
                try controller!.update(journal: journalToUpdate)
            }
            fetchJournals()
            showForm.toggle()
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Gestion des erreurs
    private func handleError(_ error: Error) {
        print("Une erreur est survenue : \(error.localizedDescription)")
    }
    
    // MARK: - Récupération des humeurs personnalisées
    private func fetchJournals() {
        do {
            journals = try controller!.getAll()
        } catch {
            handleError(error)
        }
    }
}
