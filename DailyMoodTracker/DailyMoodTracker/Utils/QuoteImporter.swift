//
//  QuoteData.swift
//  DailyMoodTracker
//
//  Created by etudiant on 10/12/2024.
//
import Foundation
import SwiftData

struct QuoteData: Codable {
    var title: String
    var author: String
    var frenchText: String
    var englishText: String
}

class QuoteImporter {
    // MARK: - Import JSON
    static func importFromJSON() -> [Quote] {
        let url = Bundle.main.url(forResource: "quotes", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        let quotes = try! decoder.decode([QuoteData].self, from: data)
        
        var quotesToReturn = [Quote]()
        for quote in quotes {
            quotesToReturn.append(Quote(
                title: quote.title,
                author: quote.author,
                frenchText: quote.frenchText,
                englishText: quote.englishText)
            )
        }
        
        return quotesToReturn
    }
}
