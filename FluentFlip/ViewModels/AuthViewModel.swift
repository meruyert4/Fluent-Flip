import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var user: User? = nil
    @Published var authErrorMessage: String?

    init() {
        checkAuthState()
    }

    func checkAuthState() {
        if let currentUser = Auth.auth().currentUser, currentUser.isEmailVerified {
            DispatchQueue.main.async {
                self.isAuthenticated = true
                self.user = User(id: currentUser.uid, name: currentUser.displayName ?? "", email: currentUser.email ?? "", status: "Available")
            }
        }
    }

    func signUpUser(email: String, password: String, username: String, completion: @escaping (Bool) -> Void) {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.authErrorMessage = error.localizedDescription
                        completion(false)
                    } else if let user = authResult?.user {
                        self.saveUserToFirestore(userId: user.uid, email: email, username: username)
                        self.sendVerificationEmail()
                        UserDefaults.standard.set(email, forKey: "EmailForSignIn")
                        completion(true)
                    }
                }
            }
        }

    private func saveUserToFirestore(userId: String, email: String, username: String) {
            let db = Firestore.firestore()
            db.collection("users").document(userId).setData([
                "id": userId,
                "name": username,
                "email": email,
                "status": "Available"
            ]) { error in
                if let error = error {
                    print("Error saving user to Firestore: \(error.localizedDescription)")
                }
            }
        }

    func sendVerificationEmail() {
        Auth.auth().currentUser?.sendEmailVerification { error in
            if let error = error {
                print("Error sending verification email: \(error.localizedDescription)")
            } else {
                print("Verification email sent!")
            }
        }
    }

    func signInUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.authErrorMessage = error.localizedDescription
                    completion(false)
                } else if let user = authResult?.user, user.isEmailVerified {
                    self.isAuthenticated = true
                    self.user = User(id: user.uid, name: user.displayName ?? "", email: user.email ?? "", status: "Available")
                    completion(true)
                } else {
                    self.authErrorMessage = "Email not verified"
                    completion(false)
                }
            }
        }
    }
    
    func verifyEmailLink(_ link: String, completion: @escaping (Bool) -> Void) {
            let auth = Auth.auth()
            if auth.isSignIn(withEmailLink: link), let email = UserDefaults.standard.string(forKey: "EmailForSignIn") {
                auth.signIn(withEmail: email, link: link) { authResult, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            self.authErrorMessage = error.localizedDescription
                            completion(false)
                        } else if let user = authResult?.user {
                            self.isAuthenticated = true
                            self.user = User(id: user.uid, name: user.displayName ?? "", email: user.email ?? "", status: "Available")
                            completion(true)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.authErrorMessage = "Invalid email link"
                    completion(false)
                }
            }
        }


    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.isAuthenticated = false
                self.user = nil
            }
        } catch {
            print("Sign out error:", error.localizedDescription)
        }
    }
}
