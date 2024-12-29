//
//  QuoteData.swift
//  DailyMoodTracker
//
//  Created by etudiant on 10/12/2024.
//
import Foundation
import SwiftData

// Le JSON contient ces clés : id, titre, texte, auteur, fr, en
// On les utilise telles quelles dans la struct.
struct QuoteData: Codable {
    let id: Int
    let titre: String    // correspond à "titre" du JSON
    let texte: String    // correspond à "texte" du JSON
    let auteur: String   // correspond à "auteur" du JSON
    let fr: String       // correspond à "fr" du JSON
    let en: String       // correspond à "en" du JSON
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
                // Conversion de QuoteData (struct) --> Quote (class SwiftData)
                let newQuote = Quote(
                    id: quoteData.id,
                    // On affecte "title" du modèle SwiftData
                    // avec la valeur "titre" du JSON
                    title: quoteData.titre,
                    // Pareil pour "author"...
                    author: quoteData.auteur,
                    // ...et pour "frenchText"...
                    frenchText: quoteData.fr,
                    // ...et "englishText".
                    englishText: quoteData.en
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
