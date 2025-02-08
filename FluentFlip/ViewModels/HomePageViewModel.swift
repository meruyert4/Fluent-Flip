//
//  HomePageViewModel.swift
//  FluentFlip
//
//  Created by Meruyert Boranbay on 08.02.2025.
//

import SwiftUI
import FirebaseFirestore
import Combine

class HomePageViewModel: ObservableObject {
    @Published var languages: [String] = []
    @Published var categories: [String] = []
    @Published var selectedLanguage: String? = nil {
        didSet {
            if let language = selectedLanguage {
                fetchCategories(for: language)
            }
        }
    }
    @Published var selectedCategory: String? = nil

    private let db = Firestore.firestore()

    /// ✅ Fetch available languages from Firestore (`languages` collection)
    func fetchLanguages() {
        db.collection("languages").getDocuments { snapshot, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching languages: \(error.localizedDescription)")
                    return
                }
                
                let fetchedLanguages = snapshot?.documents.map { $0.documentID } ?? []
                self.languages = fetchedLanguages
                
                // ✅ Set the first language as default (avoiding nil picker selection)
                if self.selectedLanguage == nil, let firstLanguage = fetchedLanguages.first {
                    self.selectedLanguage = firstLanguage
                }
            }
        }
    }

    /// ✅ Fetch categories for the selected language (`categories` subcollection)
    func fetchCategories(for language: String) {
        db.collection("languages").document(language).collection("categories").getDocuments { snapshot, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching categories: \(error.localizedDescription)")
                    return
                }

                let fetchedCategories = snapshot?.documents.map { $0.documentID } ?? []
                self.categories = fetchedCategories

                // ✅ Set the first category as default (avoiding nil picker selection)
                if self.selectedCategory == nil, let firstCategory = fetchedCategories.first {
                    self.selectedCategory = firstCategory
                }
            }
        }
    }
}
