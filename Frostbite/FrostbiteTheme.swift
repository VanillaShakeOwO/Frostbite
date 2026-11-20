
import SwiftUI

enum FrostbiteTheme {
    static let background = Color(red: 0.025, green: 0.035, blue: 0.065)
    static let panel = Color(red: 0.065, green: 0.085, blue: 0.13)
    static let panelLight = Color(red: 0.09, green: 0.12, blue: 0.18)
    static let cyan = Color(red: 0.20, green: 0.83, blue: 1.0)
    static let blue = Color(red: 0.28, green: 0.48, blue: 1.0)
    static let purple = Color(red: 0.65, green: 0.40, blue: 1.0)
    static let muted = Color(red: 0.58, green: 0.64, blue: 0.75)
    static let warning = Color.orange

    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.035, green: 0.07, blue: 0.13),
            background,
            Color(red: 0.035, green: 0.035, blue: 0.075)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct FrostbitePanel<Content: View>: View {
    let title: String
    let subtitle: String?
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)

                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(FrostbiteTheme.muted)
                }
            }

            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(FrostbiteTheme.panel)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(.white.opacity(0.07), lineWidth: 1)
                }
        }
    }
}

struct FrostbiteTag: View {
    let text: String
    var color: Color = FrostbiteTheme.cyan

    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 9, weight: .bold, design: .rounded))
            .tracking(1)
            .foregroundStyle(color)
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(color.opacity(0.13), in: Capsule())
    }
}

