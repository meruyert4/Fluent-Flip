import SwiftUI
import FirebaseFirestore
import Kingfisher

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()

    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        VStack {
            Text("🏆 Leaderboard")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("See how you rank among other users.")
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if viewModel.users.isEmpty {
                ProgressView()
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.users, id: \.id) { user in
                            LeaderboardCard(user: user)
                        }
                    }
                    .padding()
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchUsers()
        }
    }
}

struct LeaderboardCard: View {
    let user: User

    var body: some View {
        VStack {
            if let avatarURL = user.avatar {
                KFImage(avatarURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }

            Text(user.name)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)

            if !user.status.isEmpty {
                Text("“\(user.status)”")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
                    .padding(.top, 2)
            }

            Text("\(user.learnedcards ?? 0) Flashcards")
                .font(.subheadline)
                .foregroundColor(.blue)
        }
        .padding()
        .frame(width: 140, height: 160)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}


class LeaderboardViewModel: ObservableObject {
    @Published var users: [User] = []

    func fetchUsers() {
        let db = Firestore.firestore()
        db.collection("users")
            .order(by: "learnedcards", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching leaderboard: \(error.localizedDescription)")
                    return
                }

                self.users = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    return User(
                        id: doc.documentID,
                        name: data["name"] as? String ?? "Unknown",
                        email: "",
                        status: data["status"] as? String ?? "not available",
                        avatar: URL(string: data["avatar"] as? String ?? ""),
                        learnedcards: data["learnedcards"] as? Int ?? 0
                    )
                } ?? []
            }
    }
}
