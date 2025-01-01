//import SwiftUI
//import SwiftData
//import PhotosUI
//
///// Mode du formulaire (ajout ou édition)
//enum MoodFormMode {
//    case add
//    case edit(Mood)
//}
//
//struct MoodsView: View {
//    
//    // MARK: - Contrôleur
//    @StateObject private var controller = MoodController(context: <#T##ModelContext#>)
//
//    // MARK: - Humeurs via SwiftData
//    @Query var customMoods: [Mood]
//    @Environment(\.modelContext) private var context
//
//    // MARK: - Formulaire d'ajout/modification
//    @State private var showForm: Bool = false
//    @State private var formMode: MoodFormMode = .add
//
//    // Champs du formulaire
//    @State private var formName: String = ""
//    @State private var formDescription: String = ""
//    @State private var formLevel: Int16 = 5
//    @State private var formImageData: Data? = nil
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                // MARK: - Humeurs de base
//                DefaultMoodsView(moods: DefaultMoods.all)
//                
//                Divider()
//                
//                // MARK: - Humeurs personnalisées
//                Text("Mes humeurs")
//                    .font(.headline)
//                    .padding(.top, 8)
//                
//                if customMoods.isEmpty {
//                    Text("Aucune humeur personnalisée pour le moment.")
//                        .foregroundColor(.secondary)
//                        .padding()
//                } else {
//                    CustomMoodsList(
//                        moods: customMoods,
//                        onEdit: { mood in setupEditForm(with: mood) },
//                        onDelete: { mood in controller.deleteMood(mood, context: context) }
//                    )
//                }
//
//                // Bouton pour ajouter une humeur
//                Button {
//                    setupAddForm()
//                } label: {
//                    Text("Ajouter une nouvelle humeur")
//                        .bold()
//                }
//                .buttonStyle(.borderedProminent)
//                .padding(.vertical, 8)
//
//                Spacer()
//            }
//            .navigationTitle("Gestion des Humeurs")
//            .sheet(isPresented: $showForm) {
//                MoodForm(
//                    mode: formMode,
//                    name: $formName,
//                    description: $formDescription,
//                    level: $formLevel,
//                    selectedImageData: $formImageData
//                ) {
//                    performSave()
//                }
//            }
//        }
//    }
//
//    // Prépare le formulaire pour l'ajout
//    private func setupAddForm() {
//        formMode = .add
//        formName = ""
//        formDescription = ""
//        formLevel = 5
//        formImageData = nil
//        showForm = true
//    }
//
//    // Prépare le formulaire pour l'édition
//    private func setupEditForm(with mood: Mood) {
//        formMode = .edit(mood)
//        formName = mood.name
//        formDescription = mood.text
//        formLevel = mood.level
//        formImageData = mood.userImageData
//        showForm = true
//    }
//
//    // Enregistre les données selon le mode
//    private func performSave() {
//        switch formMode {
//        case .add:
//            controller.addNewMood(name: formName, text: formDescription, level: formLevel, imageData: formImageData, context: context)
//        case .edit(let mood):
//            controller.updateMood(
//                mood,
//                newName: formName,
//                newText: formDescription,
//                newLevel: formLevel,
//                newImageData: formImageData,
//                context: context
//            )
//        }
//    }
//}
