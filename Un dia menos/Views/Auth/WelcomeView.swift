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
                        NavigationLink {
                            LoginView()
                        } label: {
                            PrimaryButtonLabel(title: "Iniciar sesión", systemImage: "person.fill", tint: .red)
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            RegisterView()
                        } label: {
                            PrimaryButtonLabel(title: "Crear cuenta", systemImage: "sparkles", tint: .black)
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

// Label reutilizable (para usarlo dentro de NavigationLink)
private struct PrimaryButtonLabel: View {
    let title: String
    let systemImage: String
    let tint: Color

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
            Text(title).font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .foregroundStyle(.white)
        .background(tint, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: tint.opacity(0.22), radius: 16, x: 0, y: 10)
    }
}
