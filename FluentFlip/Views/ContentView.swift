import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        if authViewModel.isAuthenticated {
            MainTabView()
        } else {
            MainAppView()
        }
    }
}
