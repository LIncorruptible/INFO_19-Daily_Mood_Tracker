//
//  MoodForm.swift
//  DailyMoodTracker
//
//  Created by etudiant on 30/12/2024.
//

import SwiftUI
import PhotosUI

struct MoodForm: View {
    @Environment(\.dismiss) private var dismiss
    
    var mode: MoodFormMode
    @Binding var name: String
    @Binding var description: String
    @Binding var level: Int
    @Binding var selectedImageData: Data?
    
    // Picker iOS 16 pour sélectionner une image
    @State private var selectedItem: PhotosPickerItem? = nil

    // Gestion des erreurs
    @State private var nameError: String? = nil
    @State private var descriptionError: String? = nil

    /// Action à exécuter lors de la sauvegarde (création ou édition)
    let onSave: () -> Void

    var body: some View {
        NavigationView {
            Form {
                
                // SECTION INFORMATIONS
                Section("Informations") {
                    // Nom de l'humeur
                    TextField("Nom de l'humeur", text: $name)
                        .onChange(of: name) { newValue in
                            if newValue.count > 20 {
                                name = String(newValue.prefix(20))
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
                    
                    // Description
                    TextField("Description", text: $description)
                        .onChange(of: description) { newValue in
                            if newValue.count > 35 {
                                description = String(newValue.prefix(35))
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
                    
                    // Niveau (Stepper)
                    Stepper(value: $level, in: 0...10) {
                        Text("Niveau : \(level)")
                    }
                }
                
                // SECTION PHOTO
                Section("Photo") {
                    if let imageData = selectedImageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 120)
                    } else {
                        Text("Aucune photo sélectionnée.")
                            .foregroundColor(.secondary)
                    }
                    
                    // Bouton pour ouvrir le picker
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        Text("Choisir une image")
                    }
                    .onChange(of: selectedItem) { newValue in
                        Task {
                            if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                            }
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
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
        }
    }

    /// Titre de la vue, en fonction du mode
    private var title: String {
        switch mode {
            case .add: return "Nouvelle humeur"
            case .edit: return "Modifier l’humeur"
        }
    }

    /// Validation du formulaire avant sauvegarde
    private func validateForm() -> Bool {
        // Vérifie que le nom n’est pas vide
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            nameError = "Le nom est obligatoire."
            return false
        }
        
        // Vérifie que le niveau soit >= 1 (selon ta logique)
        if level < 1 {
            nameError = "Le niveau doit être supérieur ou égal à 1."
            return false
        }
        
        return true
    }
}
