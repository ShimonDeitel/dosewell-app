import SwiftUI

/// Unique visual identity for Dosewell.
enum Theme {
    static let background = Color(red: 0.114, green: 0.106, blue: 0.165)
    static let accent = Color(red: 0.608, green: 0.482, blue: 1.000)
    static let secondary = Color(red: 0.765, green: 0.698, blue: 0.918)
    static let cardBackground = background.opacity(0.92)

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)

    static let cornerRadius: CGFloat = 16
    static let spacing: CGFloat = 12
}
