import FirebaseAuth

class FirebaseService {
    static let shared = FirebaseService()

    func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
}
