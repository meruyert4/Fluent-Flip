import FirebaseFirestore
import SwiftUI

class FlashcardViewModel: ObservableObject {
    @Published var flashcards: [Flashcard] = []

    /// Fetch flashcards for a specific language and category
    func fetchFlashcards(language: String, category: String) {
        let db = Firestore.firestore()
        db.collection("languages")
            .document(language)
            .collection("categories")
            .document(category)
            .collection("flashcards")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching flashcards: \(error.localizedDescription)")
                    return
                }

                DispatchQueue.main.async {
                    self.flashcards = snapshot?.documents.compactMap { doc in
                        let data = doc.data()
                        guard let front = data["front"] as? String,
                              let back = data["back"] as? String else {
                            return nil
                        }
                        return Flashcard(id: doc.documentID, front: front, back: back)
                    } ?? []
                }
            }
    }

}
