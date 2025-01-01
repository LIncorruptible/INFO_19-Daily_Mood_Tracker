////
////  JournalsView.swift
////  DailyMoodTracker
////
////  Created by etudiant on 01/01/2025.
////
//
//import SwiftUI
//import SwiftData
//
//struct JournalsView: View {
//    @Query var journalEntries: [Journal]
//    @Environment(\.modelContext) private var context
//    @State private var showJournalForm = false
//    @State private var selectedEntry: Journal?
//
//    var body: some View {
//        NavigationStack {
//            List {
//                ForEach(journalEntries, id: \.id) { entry in
//                    NavigationLink(destination: JournalForm(entry: entry)) {
//                        VStack(alignment: .leading) {
//                            Text(entry.mood.name)
//                                .font(.headline)
//                            Text("\(entry.date, formatter: dateFormatter)")
//                                .font(.subheadline)
//                            Text(entry.notes)
//                                .font(.body)
//                                .lineLimit(2)
//                        }
//                    }
//                }
//                .onDelete(perform: deleteEntry)
//            }
//            .navigationTitle("Journal")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        showJournalForm = true
//                    }) {
//                        Image(systemName: "plus")
//                    }
//                }
//            }
//            .sheet(isPresented: $showJournalForm) {
//                JournalForm(entry: nil)
//            }
//        }
//    }
//
//    private func deleteEntry(at offsets: IndexSet) {
//        for index in offsets {
//            let entry = journalEntries[index]
//            context.delete(entry)
//        }
//        do {
//            try context.save()
//        } catch {
//            print("Erreur lors de la suppression des entrées : \(error)")
//        }
//    }
//}
//
//private let dateFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .medium
//    return formatter
//}()
