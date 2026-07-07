import SwiftUI

enum Theme {
    static let primary = Color(hex: "#004AC6")
    static let primaryContainer = Color(hex: "#2563EB")
    static let surface = Color(hex: "#FAF8FF")
    static let surfaceLow = Color(hex: "#F3F3FE")
    static let surfaceContainer = Color(hex: "#EDEDF9")
    static let surfaceHigh = Color(hex: "#E7E7F3")
    static let surfaceHighest = Color(hex: "#E1E2ED")
    static let onSurface = Color(hex: "#191B23")
    static let onSurfaceVariant = Color(hex: "#434655")
    static let secondary = Color(hex: "#585E6F")
    static let outline = Color(hex: "#737686")
    static let outlineVariant = Color(hex: "#C3C6D7")
    static let primaryFixed = Color(hex: "#DBE1FF")
    static let primaryFixedDim = Color(hex: "#B4C5FF")
    static let error = Color(hex: "#BA1A1A")
    static let tertiary = Color(hex: "#943700")
    static let success = Color(hex: "#22C55E")

    static let authAccent = Color(hex: "#2563EB")
    static let authDark = Color(hex: "#0B1220")
    static let authCard = Color.white.opacity(0.04)
    static let authBorder = Color.white.opacity(0.1)
    static let authLabel = Color.white.opacity(0.4)
    static let authInputBg = Color.white.opacity(0.06)
    static let authInputBorder = Color.white.opacity(0.12)
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
