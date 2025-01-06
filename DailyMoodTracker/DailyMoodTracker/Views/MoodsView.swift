//
//  MoodsView.swift
//  DailyMoodTracker
//
//  Created by etudiant on XX/XX/XXXX.
//

import SwiftUI
import SwiftData
import PhotosUI

/// Mode du formulaire (ajout ou édition)
enum MoodFormMode {
    case add
    case edit(Mood)
}

struct MoodsView: View {
    
    // MARK: - Humeurs
    @State private var customMoods: [Mood] = []
    @Environment(\.modelContext) private var context
    @State private var controller: MoodController?
    
    // MARK: - Formulaire d'ajout/modification
    @State private var showForm: Bool = false
    @State private var formMode: MoodFormMode = .add
    
    // Champs du formulaire
    @State private var formName: String = ""
    @State private var formDescription: String = ""
    @State private var formLevel: Int = 5
    @State private var formImageData: Data? = nil
    
    // États pour gérer les alertes d'erreur
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    
    // MARK: - Détection de l’orientation
    @State private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    
    // Grille adaptative pour les humeurs de base
    // Ajuste le minWidth selon la taille souhaitée
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 120), spacing: 16)
    ]
    
    var body: some View {
        // Remplace NavigationView par NavigationStack
        NavigationStack {
            Group {
                if isLandscape {
                    horizontalLayout()
                } else {
                    verticalLayout()
                }
            }
            // Place la toolbar et le titre ici
            .navigationTitle("Humeurs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: setupAddForm) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
        }
        // Dans .onAppear, on charge le controller et les custom moods
        .onAppear {
            detectOrientation()
            controller = MoodController(context: context)
            fetchCustomMoods()
        }
        // Détecte les changements d’orientation
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            detectOrientation()
        }
        // Feuille de formulaire
        .sheet(isPresented: $showForm) {
            MoodForm(
                mode: formMode,
                name: $formName,
                description: $formDescription,
                level: $formLevel,
                selectedImageData: $formImageData
            ) {
                performSave()
            }
        }
        // Alerte d’erreur
        .alert("Erreur", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Détection de l’orientation
    private func detectOrientation() {
        let orientation = UIDevice.current.orientation
        DispatchQueue.main.async {
            self.isLandscape = orientation.isValidInterfaceOrientation
                ? orientation.isLandscape
                : UIScreen.main.bounds.width > UIScreen.main.bounds.height
        }
    }
    
    // MARK: - Layout portrait
    @ViewBuilder
    private func verticalLayout() -> some View {
        ScrollView {
            VStack(spacing: 24) {
                // SECTION Humeurs de base
                Text("Humeurs de base")
                    .font(.headline)
                    .padding(.horizontal)
                
                LazyVGrid(columns: adaptiveColumns, spacing: 16) {
                    ForEach(DefaultMoods.all, id: \.id) { mood in
                        DefaultMoodCard(mood: mood)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // SECTION Humeurs personnalisées
                Text("Humeurs personnalisées")
                    .font(.headline)
                    .padding(.horizontal)
                
                if !customMoods.isEmpty {
                    CustomMoodsList(
                        moods: customMoods,
                        onEdit: { mood in setupEditForm(with: mood) },
                        onDelete: { mood in deleteCustomMood(mood) }
                    )
                    // On peut borner la hauteur ou laisser libre
                    .frame(minHeight: 300)
                } else {
                    Text("Aucune humeur personnalisée pour le moment.")
                        .foregroundColor(.secondary)
                        .padding(.top, 16)
                }
                
                Spacer(minLength: 20)
            }
            .padding(.top, 20)
        }
    }
    
    // MARK: - Layout paysage
    @ViewBuilder
    private func horizontalLayout() -> some View {
        // On scrolle verticalement, et on dispose 2 colonnes via un HStack
        ScrollView(.vertical) {
            HStack(alignment: .top, spacing: 32) {
                
                // Colonne de gauche : humeurs de base
                VStack(alignment: .leading, spacing: 16) {
                    Text("Humeurs de base")
                        .font(.headline)
                    
                    LazyVGrid(columns: adaptiveColumns, spacing: 16) {
                        ForEach(DefaultMoods.all, id: \.id) { mood in
                            DefaultMoodCard(mood: mood)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                // Colonne de droite : humeurs personnalisées
                VStack(alignment: .leading, spacing: 16) {
                    Text("Humeurs personnalisées")
                        .font(.headline)
                    
                    if !customMoods.isEmpty {
                        CustomMoodsList(
                            moods: customMoods,
                            onEdit: { mood in setupEditForm(with: mood) },
                            onDelete: { mood in deleteCustomMood(mood) }
                        )
                        .frame(minHeight: 400)
                        
                    } else {
                        Text("Aucune humeur personnalisée pour le moment.")
                            .foregroundColor(.secondary)
                            .padding(.top, 16)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(24)
        }
    }
    
    // MARK: - Gestion du formulaire
    private func setupAddForm() {
        formMode = .add
        formName = ""
        formDescription = ""
        formLevel = 5
        formImageData = nil
        showForm = true
    }
    
    private func setupEditForm(with mood: Mood) {
        formMode = .edit(mood)
        formName = mood.name
        formDescription = mood.text
        formLevel = mood.level
        formImageData = mood.userImageData
        showForm = true
    }
    
    private func performSave() {
        do {
            switch formMode {
            case .add:
                let moodToCreate = Mood(
                    name: formName,
                    text: formDescription,
                    level: formLevel,
                    userImageData: formImageData
                )
                try controller?.create(mood: moodToCreate)
                
            case .edit(let mood):
                let moodToUpdate = Mood(
                    id: mood.id,
                    name: formName,
                    text: formDescription,
                    level: formLevel,
                    userImageData: formImageData
                )
                try controller?.update(mood: moodToUpdate)
            }
            // Rafraîchit la liste
            fetchCustomMoods()
            showForm = false
            
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Suppression d’un mood personnalisé
    private func deleteCustomMood(_ mood: Mood) {
        do {
            try controller?.deleteById(byId: mood.id)
            fetchCustomMoods()
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Gestion des erreurs
    private func handleError(_ error: Error) {
        if let moodError = error as? MoodError {
            switch moodError {
            case .isDefaultMood(let message),
                 .alreadyExists(let message),
                 .creatingADuplicate(let message):
                errorMessage = message
            default:
                errorMessage = "Une erreur inattendue est survenue : \(moodError.localizedDescription)"
            }
        } else {
            errorMessage = "Une erreur inconnue est survenue : \(error.localizedDescription)"
        }
        showErrorAlert = true
    }
    
    // MARK: - Récupération des humeurs perso
    private func fetchCustomMoods() {
        do {
            customMoods = try controller?.getAll(withoutDefault: true) ?? []
        } catch {
            handleError(error)
        }
    }
}
