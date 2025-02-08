import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showHomePage = false
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding()
            }

            Button("Login") {
                authViewModel.signInUser(email: email, password: password) { success in
                    if success {
                        showHomePage = true
                    } else {
                        errorMessage = authViewModel.authErrorMessage
                    }
                }
            }
            .padding()
            .buttonStyle(.borderedProminent)

        }
        .padding()
        .fullScreenCover(isPresented: $showHomePage) {
            HomePage().environmentObject(authViewModel)
        }
    }
}
