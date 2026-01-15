import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var auth: AuthService
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Crear cuenta")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))

                GlassCard {
                    VStack(spacing: 14) {
                        BrandField(title: "Email", text: $email)
                        BrandField(title: "Contraseña", text: $password, isSecure: true)

                        PrimaryButton(title: auth.isLoading ? "Creando..." : "Crear", systemImage: "person.badge.plus") {
                            Task { await auth.signUp(email: email, password: password) }
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
