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
    
    var body: some View {
        NavigationView {
            
            VStack(spacing: 20) {
                
                Spacer()
                
                // Humeurs par Défaut
                VStack(alignment: .leading) {
                    Text("Humeurs de base")
                        .font(.headline)
                    
                    Spacer()
                    
                    DefaultMoodsView(moods: DefaultMoods.all)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Humeurs personnalisées
                VStack(alignment: .leading, spacing: 10) {
                    
                    
                    if !customMoods.isEmpty {
                        Text("Humeurs personnalisées")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        CustomMoodsList(
                            moods: customMoods,
                            onEdit: { mood in
                                setupEditForm(with: mood)
                            },
                            onDelete: { mood in
                                do {
                                    try controller?.deleteById(byId: mood.id)
                                    fetchCustomMoods()
                                } catch {
                                    handleError(error)
                                }
                            }
                        )
                        .padding(.horizontal)
                    } else {
                        Spacer()
                        
                        VStack(spacing: 16) {
                            Image(systemName: "tray")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)
                            
                            Text("Aucune humeur personnalisée pour le moment.")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
            }
        }
        .navigationTitle("Humeurs")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: setupAddForm) {
                    Image(systemName: "plus")
                        .font(.title2)
                }
            }
        }
        .onAppear {
            controller = MoodController(context: context)
            fetchCustomMoods()
        }
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
        .alert("Erreur", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }

    // MARK: - Prépare le formulaire pour l'ajout
    private func setupAddForm() {
        formMode = .add
        formName = ""
        formDescription = ""
        formLevel = 5
        formImageData = nil
        showForm = true
    }

    // MARK: - Prépare le formulaire pour l'édition
    private func setupEditForm(with mood: Mood) {
        formMode = .edit(mood)
        formName = mood.name
        formDescription = mood.text
        formLevel = mood.level
        formImageData = mood.userImageData
        showForm = true
    }

    // MARK: - Enregistre les données selon le mode
    private func performSave() {
        do {
            switch formMode {
            case .add:
                let moodToCreate: Mood = Mood(
                    name: formName,
                    text: formDescription,
                    level: formLevel,
                    userImageData: formImageData
                )
                try controller?.create(mood: moodToCreate)
            case .edit(let mood):
                let moodToUpdate: Mood = Mood(
                    id: mood.id,
                    name: formName,
                    text: formDescription,
                    level: formLevel,
                    userImageData: formImageData
                )
                try controller?.update(mood: moodToUpdate)
            }
            fetchCustomMoods()
            showForm = false
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

    // MARK: - Récupération des humeurs personnalisées
    private func fetchCustomMoods() {
        do {
            customMoods = try controller?.getAll(withoutDefault: true) ?? []
        } catch {
            handleError(error)
        }
    }
}
