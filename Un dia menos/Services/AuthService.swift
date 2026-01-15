import Foundation
import Combine
import Supabase

@MainActor
final class AuthService: ObservableObject {
    @Published var sessionUserId: UUID? = nil
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    func bootstrap() async {
        do {
            let session = try await SupabaseManager.client.auth.session
            sessionUserId = session.isExpired ? nil : session.user.id
            print("🔁 bootstrap sessionUserId=\(String(describing: sessionUserId)) expired=\(session.isExpired)")
        } catch {
            sessionUserId = nil
            print("ℹ️ bootstrap no session: \(error.localizedDescription)")
        }
    }

    func signIn(email: String, password: String) async {
        isLoading = true; errorMessage = nil
        defer { isLoading = false }

        do {
            print("🔐 signIn start")
            let res = try await SupabaseManager.client.auth.signIn(email: email, password: password)
            sessionUserId = res.user.id
            print("✅ signIn ok userId=\(res.user.id)")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ signIn error: \(error.localizedDescription)")
        }
    }

    func signUp(email: String, password: String) async {
        isLoading = true; errorMessage = nil
        defer { isLoading = false }

        do {
            print("✨ signUp start")
            let res = try await SupabaseManager.client.auth.signUp(email: email, password: password)
            sessionUserId = res.user.id
            print("✅ signUp ok userId=\(res.user.id)")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ signUp error: \(error.localizedDescription)")
        }
    }

    func signOut() async {
        isLoading = true; errorMessage = nil
        defer { isLoading = false }

        do {
            try await SupabaseManager.client.auth.signOut()
            sessionUserId = nil
            print("👋 signed out")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ signOut error: \(error.localizedDescription)")
        }
    }
}
