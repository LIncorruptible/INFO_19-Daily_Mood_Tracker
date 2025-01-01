//
//  DefaultMoods.swift
//  DailyMoodTracker
//
//  Created by etudiant on 30/12/2024.
//


import SwiftUI

struct DefaultMoods {
    static let all: [Mood] = [
        Mood(name: "Triste", text: "Humeur plutôt négative", level: 2, image: "mood_sad"),
        Mood(name: "Mélancolique", text: "Un peu morose", level: 4, image: "mood_melancolique"),
        Mood(name: "Neutre", text: "Ni triste, ni joyeux", level: 6, image: "mood_neutre"),
        Mood(name: "Enthousiaste", text: "Humeur motivée", level: 8, image: "mood_enthousiaste"),
        Mood(name: "Exalté", text: "Joie très intense", level: 10, image: "mood_exalte")
    ]
}