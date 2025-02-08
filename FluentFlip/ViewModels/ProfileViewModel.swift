import SwiftUI
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var currentUser: User?

    func fetchUserProfile() {
        guard let userId = FirebaseService.shared.getCurrentUserId() else { return }

        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user profile: \(error.localizedDescription)")
                return
            }

            if let data = snapshot?.data() {
                self.currentUser = User(
                    id: userId,
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    status: data["status"] as? String ?? "Available",
                    avatar: (data["avatar"] as? String).flatMap { URL(string: $0) },
                    learnedcards: data["learnedcards"] as? Int ?? 0
                )
            }
        }
    }
    
    func updateUserAvatar(url: URL) {
        currentUser?.avatar = url

        guard let userId = FirebaseService.shared.getCurrentUserId() else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(userId).updateData([
            "avatar": url.absoluteString
        ]) { error in
            if let error = error {
                print("Error updating avatar: \(error.localizedDescription)")
            } else {
                print("Avatar URL successfully updated in Firebase")
            }
        }
    }

    func updateUserStatus(_ newStatus: String) {
        currentUser?.status = newStatus

        guard let userId = FirebaseService.shared.getCurrentUserId() else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(userId).updateData([
            "status": newStatus
        ]) { error in
            if let error = error {
                print("Error updating status: \(error.localizedDescription)")
            } else {
                print("Status successfully updated in Firebase")
            }
        }
    }
}
