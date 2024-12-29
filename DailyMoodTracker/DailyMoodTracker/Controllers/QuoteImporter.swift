//
//  QuoteData.swift
//  DailyMoodTracker
//
//  Created by etudiant on 10/12/2024.
//


import Foundation
import SwiftData

struct QuoteData: Codable {
    let id: Int
    let title: String
    let frenchText: String
    let englishText: String
    let author: String
}

class QuoteImporter {
    static func importQuotes(from jsonFile: String, context: ModelContext) {
        guard let url = Bundle.main.url(forResource: jsonFile, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Erreur : Fichier JSON introuvable.")
            return
        }

        do {
            let decoder = JSONDecoder()
            let quotesArray = try decoder.decode([QuoteData].self, from: data)

            for quoteData in quotesArray {
                let newQuote = Quote(
                    id: quoteData.id,
                    title: quoteData.title,
                    author: quoteData.author,
                    frenchText: quoteData.frenchText,
                    englishText: quoteData.englishText
                )
                context.insert(newQuote)
            }

            try context.save()
            print("Citations importées avec succès.")
        } catch {
            print("Erreur lors de l'importation des citations : \(error)")
        }
    }
}
