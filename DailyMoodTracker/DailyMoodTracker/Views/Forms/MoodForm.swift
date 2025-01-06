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
    @State private var selectedItem: PhotosPickerItem? = nil

    // Gestion des erreurs
    @State private var nameError: String? = nil
    @State private var descriptionError: String? = nil

    let onSave: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section("Informations") {
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
                    
                    Stepper(value: $level, in: 0...10) {
                        Text("Niveau : \(level)")
                    }
                }
                Section("Aperçu de l'image sélectionnée") {
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
        }
    }

    private var title: String {
        switch mode {
            case .add: return "Nouvelle humeur"
            case .edit: return "Modifier l’humeur"
        }
    }

    private func validateForm() -> Bool {
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            nameError = "Le nom est obligatoire."
            return false
        }
        if level < 1 {
            nameError = "Le niveau doit être supérieur ou égal à 1."
            return false
        }
        return true
    }
}
