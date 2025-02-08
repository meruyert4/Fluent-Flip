import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedView: AuthView? = nil

    enum AuthView {
        case login, register
    }

    var body: some View {
        ZStack {
            // Градиентный фон
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.white]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 25) {
                Spacer()

                // Логотип и заголовки
                VStack(spacing: 5) {
                    Image(systemName: "book.fill") // Placeholder logo
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                        .padding(.bottom, 10)

                    Text("FluentFlip")
                        .font(.largeTitle.bold())
                        .foregroundColor(.blue)
                        .shadow(color: .blue.opacity(0.3), radius: 3, x: 0, y: 3)

                    Text("Master languages with flashcards!")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                Spacer()

                if selectedView == nil {
                    // Кнопки выбора авторизации
                    VStack(spacing: 20) {
                        AuthButton(title: "Log In", color: Color.blue) {
                            withAnimation(.spring()) {
                                selectedView = .login
                            }
                        }

                        AuthButton(title: "Register", color: Color.green) {
                            withAnimation(.spring()) {
                                selectedView = .register
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                } else {
                    // Контейнер с формой входа/регистрации
                    VStack {
                        VStack {
                            if selectedView == .login {
                                LoginView()
                                    .environmentObject(authViewModel)
                            } else {
                                RegisterView()
                                    .environmentObject(authViewModel)
                            }

                            Button("Back to Selection") {
                                withAnimation(.spring()) {
                                    selectedView = nil
                                }
                            }
                            .foregroundColor(.red)
                            .padding(.top, 20)
                        }
                        .padding()
                        .background(.ultraThinMaterial) // Размытие вместо белого квадрата
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .transition(.slide)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .animation(.easeInOut, value: selectedView)
    }
}

// Кастомный стиль кнопок
struct AuthButton: View {
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(color.gradient)
                .foregroundColor(.white)
                .font(.headline)
                .cornerRadius(12)
                .shadow(color: color.opacity(0.3), radius: 5, x: 0, y: 3)
        }
    }
}
