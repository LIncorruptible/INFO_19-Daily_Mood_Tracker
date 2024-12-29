//
//  ContentView.swift
//  DailyMoodTracker
//
//  Created by etudiant on 10/12/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \Quote.id) private var quotes: [Quote]

    var body: some View {
        NavigationView {
            List(quotes, id: \.id) { quote in
                VStack(alignment: .leading) {
                    Text(quote.frenchText).font(.headline)
                    Text("- \(quote.author)").font(.subheadline).italic()
                }
            }
            .navigationTitle("Motivational Quotes")
        }
    }
}
