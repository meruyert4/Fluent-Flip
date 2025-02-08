import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showHomePage = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle.bold())
                .padding()
                .foregroundColor(.blue)

            VStack(alignment: .leading, spacing: 10) {
                Text("Email")
                    .font(.headline)
                    .foregroundColor(.gray)
                TextField("Enter your email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.horizontal)

                Text("Password")
                    .font(.headline)
                    .foregroundColor(.gray)
                SecureField("Enter your password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
            .padding()

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding()
            }

            Button(action: {
                authViewModel.signInUser(email: email, password: password) { success in
                    if success {
                        showHomePage = true
                    } else {
                        errorMessage = authViewModel.authErrorMessage
                    }
                }
            }) {
                Text("Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $showHomePage) {
            HomePage().environmentObject(authViewModel)
        }
    }
}
