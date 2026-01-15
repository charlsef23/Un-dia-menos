import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthService
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Iniciar sesión")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))

                GlassCard {
                    VStack(spacing: 14) {
                        BrandField(title: "Email", text: $email)
                        BrandField(title: "Contraseña", text: $password, isSecure: true)

                        PrimaryButton(title: auth.isLoading ? "Entrando..." : "Entrar", systemImage: "arrow.right") {
                            Task { await auth.signIn(email: email, password: password) }
                        }
                        .disabled(auth.isLoading || email.isEmpty || password.isEmpty)

                        if let e = auth.errorMessage {
                            Text(e).font(.footnote).foregroundStyle(.red)
                        }
                    }
                }
            }
            .padding(18)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
