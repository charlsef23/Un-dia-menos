import SwiftUI

struct RootView: View {
    @EnvironmentObject var auth: AuthService

    var body: some View {
        Group {
            if auth.sessionUserId == nil {
                WelcomeView()
            } else {
                MainTabView()
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: auth.sessionUserId)
    }
}

private struct MainTabView: View {
    var body: some View {
        TabView {
            EventsListView()
                .tabItem { Label("Eventos", systemImage: "calendar") }

            SettingsView()
                .tabItem { Label("Ajustes", systemImage: "gearshape") }
        }
    }
}
