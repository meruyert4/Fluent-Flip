import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedView: AuthView? = nil

    enum AuthView {
        case login, register
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()

                Text("FluentFlip")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)

                Text("Master languages with flashcards!")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Spacer()

                if selectedView == nil {
                    VStack(spacing: 15) {
                        Button("Log In") {
                            selectedView = .login
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)

                        Button("Register") {
                            selectedView = .register
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                    }
                } else {
                    if selectedView == .login {
                        LoginView()
                            .environmentObject(authViewModel)
                    } else {
                        RegisterView()
                            .environmentObject(authViewModel)
                    }

                    Button("Back to Selection") {
                        selectedView = nil
                    }
                    .foregroundColor(.red)
                    .padding()
                }

                Spacer()
            }
            .padding()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
