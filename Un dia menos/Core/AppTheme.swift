import SwiftUI

enum Brand {
    static let accent = Color.red
    static let bg = Color(.systemBackground)
    static let subtle = Color(.secondarySystemBackground)
    static let textSecondary = Color.secondary

    static func accent(hex: String) -> Color {
        Color(hex: hex) ?? .red
    }
}

extension Color {
    init?(hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hex.hasPrefix("#") { hex.removeFirst() }
        guard hex.count == 6 else { return nil }

        var rgb: UInt64 = 0
        guard Scanner(string: hex).scanHexInt64(&rgb) else { return nil }
        let r = Double((rgb & 0xFF0000) >> 16) / 255
        let g = Double((rgb & 0x00FF00) >> 8) / 255
        let b = Double(rgb & 0x0000FF) / 255
        self = Color(red: r, green: g, blue: b)
    }
}
