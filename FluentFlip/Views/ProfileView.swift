import SwiftUI
import Kingfisher

struct ProfileView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var avatarURLInput: String = ""
    @State private var isEditingStatus: Bool = false
    @State private var newStatus: String = ""

    var body: some View {
        VStack {
            if let user = profileViewModel.currentUser {
                VStack {
                    // Avatar Section
                    if let avatarURL = user.avatar {
                        KFImage(avatarURL)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
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

                    // Editable Status Section
                    HStack {
                        if isEditingStatus {
                            TextField("Enter new status", text: $newStatus)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 200)
                            
                            Button(action: {
                                profileViewModel.updateUserStatus(newStatus)
                                isEditingStatus = false
                            }) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.title2)
                            }
                        } else {
                            Text("Status: \(user.status)")
                                .font(.body)
                                .foregroundColor(.blue)
                            
                            Button(action: {
                                newStatus = user.status
                                isEditingStatus = true
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.gray)
                                    .font(.title2)
                            }
                        }
                    }
                    .padding(.top, 5)
                    
                    // Avatar URL input field
                    TextField("Enter Avatar URL", text: $avatarURLInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(maxWidth: .infinity)
                    
                    Button(action: {
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
            } else {
                ProgressView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    authViewModel.signOut()
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }
        }
        .padding()

        .onAppear {
            profileViewModel.fetchUserProfile()
        }
    }
}
