import SwiftUI

struct PrimaryButton: View {
    let title: String
    var systemImage: String? = nil
    var tint: Color = .red
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let systemImage { Image(systemName: systemImage) }
                Text(title).font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .foregroundStyle(.white)
            .background(tint, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: tint.opacity(0.22), radius: 16, x: 0, y: 10)
        }
        .buttonStyle(.plain)
    }
}
