import SwiftUI
import Kingfisher

struct ProfileView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var avatarURLInput: String = ""

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
                    
                    // Avatar URL input field
                    TextField("Enter Avatar URL", text: $avatarURLInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        // Update avatar URL when button is tapped
                        if let newAvatarURL = URL(string: avatarURLInput) {
                            profileViewModel.updateUserAvatar(url: newAvatarURL)
                        }
                    }) {
                        Text("Update Avatar")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
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
