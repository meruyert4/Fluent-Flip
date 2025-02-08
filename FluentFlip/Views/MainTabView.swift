import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel

    var body: some View {
        TabView {
            HomePage()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            ProgressView()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.fill")
                }

            LeaderboardView()
                .tabItem {
                    Label("Leaderboard", systemImage: "trophy.fill")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}
