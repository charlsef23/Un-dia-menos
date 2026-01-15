import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Brand.bg.ignoresSafeArea()

                VStack(spacing: 18) {
                    Spacer()

                    VStack(spacing: 10) {
                        Text("Un día menos")
                            .font(.system(size: 38, weight: .semibold, design: .rounded))
                        Text("Cuenta atrás para lo que de verdad importa.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 28)
                    }

                    Spacer()

                    VStack(spacing: 12) {
                        NavigationLink { LoginView() } label: {
                            PrimaryButton(title: "Iniciar sesión", systemImage: "person.fill") {}
                        }
                        .buttonStyle(.plain)

                        NavigationLink { RegisterView() } label: {
                            PrimaryButton(title: "Crear cuenta", systemImage: "sparkles", tint: .black) {}
                        }
                        .buttonStyle(.plain)

                        Text("Minimalista • Fotos y vídeos • Tiempo real")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .padding(.top, 8)
                    }
                    .padding(.horizontal, 18)

                    Spacer().frame(height: 20)
                }
            }
            .navigationBarHidden(true)
        }
    }
}
