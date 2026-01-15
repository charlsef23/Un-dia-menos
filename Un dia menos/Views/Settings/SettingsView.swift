import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var auth: AuthService

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Cuenta")
                            .font(.headline)
                        Text("Gestiona sesión y preferencias.")
                            .foregroundStyle(.secondary)

                        PrimaryButton(title: auth.isLoading ? "Saliendo..." : "Cerrar sesión", systemImage: "rectangle.portrait.and.arrow.right", tint: .black) {
                            Task { await auth.signOut() }
                        }
                        .disabled(auth.isLoading)
                    }
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Un día menos")
                            .font(.headline)
                        Text("v1 • SwiftUI + Supabase")
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                    }
                }

                Spacer()
            }
            .padding(18)
            .navigationTitle("Ajustes")
        }
    }
}
