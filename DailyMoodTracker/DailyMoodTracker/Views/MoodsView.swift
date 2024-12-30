import SwiftUI
import SwiftData
import PhotosUI

/// Mode du formulaire (ajout ou édition)
enum MoodFormMode {
    case add
    case edit(Mood)
}

struct MoodsView: View {
    
    // MARK: - Contrôleur
    @StateObject private var controller = MoodsController()

    // MARK: - Humeurs de base (non éditables)
    let defaultMoods: [Mood] = [
        Mood(name: "Triste", text: "Humeur plutôt négative", level: 2, image: "mood_sad"),
        Mood(name: "Mélancolique", text: "Un peu morose", level: 4, image: "mood_melancolique"),
        Mood(name: "Neutre", text: "Ni triste, ni joyeux", level: 6, image: "mood_neutre"),
        Mood(name: "Enthousiaste", text: "Humeur motivée", level: 8, image: "mood_enthousiaste"),
        Mood(name: "Exalté", text: "Joie très intense", level: 10, image: "mood_exalte")
    ]
    
    // MARK: - Humeurs via SwiftData
    @Query var customMoods: [Mood]
    @Environment(\.modelContext) private var context

    // MARK: - Un seul formulaire (Add/Edit)
    @State private var showForm: Bool = false
    @State private var formMode: MoodFormMode = .add

    // Champs communs du formulaire
    @State private var formName: String = ""
    @State private var formDescription: String = ""
    @State private var formLevel: Int16 = 5
    @State private var formSelectedItem: PhotosPickerItem? = nil
    @State private var formImageData: Data? = nil

    // Gestion des erreurs
    @State private var nameError: String? = nil
    @State private var descriptionError: String? = nil

    var body: some View {
        NavigationView {
            VStack {
                // Humeurs de base
                Text("Humeurs de base")
                    .font(.headline)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        // Première ligne : 3 humeurs
                        HStack(spacing: 16) {
                            ForEach(defaultMoods[0..<3], id: \.id) { mood in
                                baseMoodView(mood)
                            }
                        }
                        // Deuxième ligne : 2 humeurs
                        HStack(spacing: 16) {
                            ForEach(defaultMoods[3..<5], id: \.id) { mood in
                                baseMoodView(mood)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
                
                Divider()
                
                // Humeurs personnalisées
                Text("Mes humeurs")
                    .font(.headline)
                    .padding(.top, 8)
                
                if customMoods.isEmpty {
                    Text("Aucune humeur personnalisée pour le moment.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List {
                        ForEach(customMoods, id: \.id) { mood in
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

                                // Nom et description de l'humeur
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
                                    setupEditForm(with: mood)
                                } label: {
                                    Label("Modifier", systemImage: "pencil")
                                }

                                Button(role: .destructive) {
                                    controller.deleteMood(mood, context: context)
                                    print("Supprimé : \(mood.name)")
                                } label: {
                                    Label("Supprimer", systemImage: "trash")
                                }
                            }
                        }
                        .listStyle(.inset)
                    }
                }

                // Bouton pour ajouter une humeur
                Button {
                    setupAddForm()
                } label: {
                    Text("Ajouter une nouvelle humeur")
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                .padding(.vertical, 8)

                Spacer()
            }
            .navigationTitle("Gestion des Humeurs")
            .sheet(isPresented: $showForm) {
                unifiedMoodForm
            }
        }
    }
    
    // Vue pour une humeur de base
    @ViewBuilder
    private func baseMoodView(_ mood: Mood) -> some View {
        VStack(spacing: 4) {
            if let imageName = mood.image, !imageName.isEmpty {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            } else {
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
            Text(mood.name)
                .font(.caption)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(8)
    }

    // Formulaire unifié
    @ViewBuilder
    private var unifiedMoodForm: some View {
        NavigationView {
            Form {
                Section("Informations") {
                    TextField("Nom de l'humeur", text: $formName)
                        .onChange(of: formName) { newValue in
                            if newValue.count > 20 {
                                formName = String(newValue.prefix(20))
                                nameError = "Le nom ne peut pas dépasser 20 caractères."
                            } else {
                                nameError = nil
                            }
                        }
                    if let nameError = nameError {
                        Text(nameError)
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                    
                    TextField("Description", text: $formDescription)
                        .onChange(of: formDescription) { newValue in
                            if newValue.count > 35 {
                                formDescription = String(newValue.prefix(35))
                                descriptionError = "La description ne peut pas dépasser 35 caractères."
                            } else {
                                descriptionError = nil
                            }
                        }
                    if let descriptionError = descriptionError {
                        Text(descriptionError)
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                    
                    Section {
                        Stepper(value: $formLevel, in: 0...10) {
                            Text("Niveau : \(formLevel)")
                        }
                    } header: {
                        Text("Niveau (0 = très négatif, 10 = très positif)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                Section("Aperçu de l'image sélectionnée") {
                    if let imageData = formImageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 120)
                    } else {
                        Text("Aucune photo sélectionnée.")
                            .foregroundColor(.secondary)
                    }
                    PhotosPicker(selection: $formSelectedItem, matching: .images, photoLibrary: .shared()) {
                        Text("Choisir une image")
                    }
                    .onChange(of: formSelectedItem) { newValue in
                        Task {
                            if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                formImageData = data
                            }
                        }
                    }
                }
            }
            .navigationTitle(formTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { showForm = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        if validateForm() {
                            performSave()
                            showForm = false
                        }
                    }
                }
            }
        }
    }

    private var formTitle: String {
        switch formMode {
        case .add:
            return "Nouvelle humeur"
        case .edit(let mood):
            return "Modification de l'humeur \(mood.name)"
        }
    }
    
    private func setupEditForm(with mood: Mood) {
        if showForm {
            showForm = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            formMode = .edit(mood)
            formName = mood.name
            formDescription = mood.text
            formLevel = mood.level
            formSelectedItem = nil
            formImageData = mood.userImageData
            showForm = true
        }
    }
    
    private func setupAddForm() {
        formMode = .add
        formName = ""
        formDescription = ""
        formLevel = 5
        formSelectedItem = nil
        formImageData = nil
        showForm = true
    }

    private func performSave() {
        switch formMode {
        case .add:
            controller.addNewMood(name: formName, text: formDescription, level: formLevel, imageData: formImageData, context: context)
        case .edit(let mood):
            mood.name = formName
            mood.text = formDescription
            mood.level = formLevel
            mood.userImageData = formImageData
            try? context.save()
        }
    }

    private func validateForm() -> Bool {
        var isValid = true
        if formName.trimmingCharacters(in: .whitespaces).isEmpty {
            nameError = "Le nom est obligatoire."
            isValid = false
        }
        if formLevel < 1 {
            nameError = "Le niveau doit être au moins 1."
            isValid = false
        }
        return isValid
    }
}
