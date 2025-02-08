import SwiftUI
import FirebaseFirestore

struct FlashcardView: View {
    @StateObject private var viewModel = FlashcardViewModel()
    @EnvironmentObject var profileViewModel: ProfileViewModel
    let language: String
    let category: String

    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var learnedFlashcards = Set<String>()
    var body: some View {
        VStack {
            Text("Flashcards for \(category) in \(language)")
                .font(.title2)
                .padding()
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            if viewModel.flashcards.isEmpty {
                Text("No flashcards available.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                FlashcardViewItem(flashcard: viewModel.flashcards[currentIndex], isFlipped: $isFlipped)
                    .frame(height: 200)
                    .padding()
                    .frame(maxWidth: .infinity)

                HStack {
                    Button(action: {
                        isFlipped = false
                        currentIndex = (currentIndex - 1 + viewModel.flashcards.count) % viewModel.flashcards.count
                    }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                    }

                    Spacer()

                    Button(action: {
                        isFlipped = false
                        currentIndex = (currentIndex + 1) % viewModel.flashcards.count
                    }) {
                        Image(systemName: "arrow.right")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
                .padding()

                HStack {
                    Button("I Don't Know") {
                        isFlipped = false
                        currentIndex = (currentIndex + 1) % viewModel.flashcards.count
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("I Know") {
                        markFlashcardAsLearned()
                        isFlipped = false
                        currentIndex = (currentIndex + 1) % viewModel.flashcards.count
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 40)
            }
        }
        .onAppear {
            viewModel.fetchFlashcards(language: language, category: category)
        }
    }

    private func markFlashcardAsLearned() {
        let currentFlashcard = viewModel.flashcards[currentIndex]

        // Prevent multiple counts for the same flashcard
        guard !learnedFlashcards.contains(currentFlashcard.id) else { return }

        learnedFlashcards.insert(currentFlashcard.id) // Mark as learned

        guard let userId = profileViewModel.currentUser?.id else { return }
        let userRef = Firestore.firestore().collection("users").document(userId)

        userRef.updateData([
            "learnedcards": FieldValue.increment(Int64(1))
        ]) { error in
            if let error = error {
                print("Error updating learned cards: \(error.localizedDescription)")
            } else {
                profileViewModel.currentUser?.learnedcards? += 1
            }
        }
    }
}


struct FlashcardViewItem: View {
    let flashcard: Flashcard
    @Binding var isFlipped: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 5)
                .frame(height: 200)
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
                .overlay(
                    Text(isFlipped ? flashcard.back : flashcard.front)
                        .font(.title)
                        .padding()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                )
        }
        .frame(maxWidth: .infinity)
        .padding()
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                isFlipped.toggle()
            }
        }
    }
}
