import SwiftUI
import Kingfisher

struct ProfileView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            if let user = profileViewModel.currentUser {
                VStack {
                    if let avatarURL = user.avatar {
                        KFImage(avatarURL)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            .shadow(radius: 5)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                    }

                    Text(user.name)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(user.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text("Status: \(user.status)")
                        .font(.body)
                        .foregroundColor(.blue)
                        .padding(.top, 5)

                    Text("Learned Flashcards: \(user.learnedcards ?? 0)")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding(.top, 10)
                }
                .padding()

                Spacer()

                Button(action: {
                    authViewModel.signOut()
                }) {
                    Text("Sign Out")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
            } else {
                ProgressView()
            }
        }
        .padding()
        .onAppear {
            profileViewModel.fetchUserProfile()
        }
    }
}
