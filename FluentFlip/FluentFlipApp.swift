import SwiftUI
import Firebase

@main
struct FluentFlipApp: App {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var profileViewModel = ProfileViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(profileViewModel)
        }
    }
}
