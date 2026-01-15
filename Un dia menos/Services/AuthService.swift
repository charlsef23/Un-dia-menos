import Foundation
import Supabase

@MainActor
final class AuthService: ObservableObject {
    @Published var sessionUserId: UUID? = nil
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    func bootstrap() async {
        do {
            let session = try await SupabaseManager.client.auth.session
            sessionUserId = session.user.id
        } catch {
            sessionUserId = nil
        }
    }

    func signIn(email: String, password: String) async {
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do {
            let res = try await SupabaseManager.client.auth.signIn(email: email, password: password)
            sessionUserId = res.user.id
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signUp(email: String, password: String) async {
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do {
            let res = try await SupabaseManager.client.auth.signUp(email: email, password: password)
            sessionUserId = res.user.id
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() async {
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do {
            try await SupabaseManager.client.auth.signOut()
            sessionUserId = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
