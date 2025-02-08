import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var username = ""
    @State private var isVerificationSent = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("Register")
                .font(.largeTitle)
                .padding()

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if let errorMessage = authViewModel.authErrorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            if isVerificationSent {
                Text("A verification link has been sent to \(email). Please check your inbox and verify your email before signing in.")
                    .foregroundColor(.blue)
                    .padding()
                
                Button("Sign In") {
                    authViewModel.signInUser(email: email, password: password) { success in
                        if success { dismiss() }
                    }
                }
                .padding()
                .buttonStyle(.borderedProminent)
            } else {
                Button("Sign Up") {
                    signUpUser()
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .onOpenURL { url in
            authViewModel.verifyEmailLink(url.absoluteString) { success in
                if success { dismiss() }
            }
        }
    }

    private func signUpUser() {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty, !username.isEmpty else {
            authViewModel.authErrorMessage = "All fields are required!"
            return
        }

        guard password == confirmPassword else {
            authViewModel.authErrorMessage = "Passwords do not match!"
            return
        }

        authViewModel.signUpUser(email: email, password: password, username: username) { success in
            if success { isVerificationSent = true }
        }
    }
}
