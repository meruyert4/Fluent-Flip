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
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)

            VStack {
                Text("\(category) - \(language)")
                    .font(.title2.bold())
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .shadow(radius: 2)

                if viewModel.flashcards.isEmpty {
                    Text("No flashcards available.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    FlashcardViewItem(flashcard: viewModel.flashcards[currentIndex], isFlipped: $isFlipped)
                        .frame(height: 220)
                        .padding()
                        .frame(maxWidth: .infinity)

                    HStack {
                        Button(action: previousCard) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                        .shadow(radius: 2)

                        Spacer()

                        Text("\(currentIndex + 1) / \(viewModel.flashcards.count)")
                            .foregroundColor(.black)
                            .font(.headline)
                        
                        Spacer()

                        Button(action: nextCard) {
                            Image(systemName: "arrow.right")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                    }
                    .padding()

                    HStack {
                        Button("I Don't Know") {
                            nextCard()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 2)

                        Button("I Know") {
                            markFlashcardAsLearned()
                            nextCard()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                    }
                    .padding(.horizontal, 40)
                }
            }
            .onAppear {
                viewModel.fetchFlashcards(language: language, category: category)
            }
        }
    }

    private func previousCard() {
        isFlipped = false
        currentIndex = (currentIndex - 1 + viewModel.flashcards.count) % viewModel.flashcards.count
    }

    private func nextCard() {
        isFlipped = false
        currentIndex = (currentIndex + 1) % viewModel.flashcards.count
    }

    private func markFlashcardAsLearned() {
        let currentFlashcard = viewModel.flashcards[currentIndex]
        guard !learnedFlashcards.contains(currentFlashcard.id) else { return }

        learnedFlashcards.insert(currentFlashcard.id)
        guard let userId = profileViewModel.currentUser?.id else { return }
        let userRef = Firestore.firestore().collection("users").document(userId)

        userRef.updateData([
            "learnedcards": FieldValue.increment(Int64(1))
        ]) { error in
            if error == nil {
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
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(radius: 5)
                .frame(height: 220)
                .overlay(
                    Text(isFlipped ? flashcard.back : flashcard.front)
                        .font(.title2.bold())
                        .padding()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .opacity(isFlipped ? 0.7 : 1.0)
                )
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isFlipped.toggle()
                    }
                }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}
