import SwiftUI

@main
struct UnDiaMenosApp: App {
    @StateObject private var auth = AuthService()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(auth)
                .task { await auth.bootstrap() }
        }
    }
}
