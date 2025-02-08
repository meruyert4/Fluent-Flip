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
        VStack(spacing: 20) {
            Text("Register")
                .font(.largeTitle.bold())
                .padding()
                .foregroundColor(.blue)

            TextField("Username", text: $username)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)

            TextField("Email", text: $email)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)

            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)

            if let errorMessage = authViewModel.authErrorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            if isVerificationSent {
                Text("A verification link has been sent to \(email). Please check your inbox and verify your email before signing in.")
                    .foregroundColor(.blue)
                    .padding()
                    .multilineTextAlignment(.center)

                Button("Sign In") {
                    authViewModel.signInUser(email: email, password: password) { success in
                        if success { dismiss() }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(15)
                .padding(.horizontal)
            } else {
                Button("Sign Up") {
                    signUpUser()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
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
