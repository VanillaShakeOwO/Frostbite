import SwiftUI

struct LiquidGlassStudioView: View {
    @State private var blur = 18.0
    @State private var contrast = 0.72
    @State private var tint = Color.cyan
    @State private var material: MaterialChoice = .regular

    private enum MaterialChoice: String, CaseIterable, Identifiable {
        case ultraThin = "Ultra thin"
        case thin = "Thin"
        case regular = "Regular"
        case thick = "Thick"
        var id: String { rawValue }

        var material: Material {
            switch self {
            case .ultraThin: return .ultraThin
            case .thin: return .thin
            case .regular: return .regular
            case .thick: return .thick
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                FrostbiteTheme.backgroundGradient.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            FrostbiteTag(text: "Liquid Glass Studio")
                            Text("Tune the
surface.")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            Text("Explore material, tint, blur and contrast combinations.")
                                .font(.subheadline)
                                .foregroundStyle(FrostbiteTheme.muted)
                        }

                        FrostbitePanel(title: "Glass preview", subtitle: "Applied to this preview card only") {
                            ZStack {
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(
                                        LinearGradient(
                                            colors: [tint.opacity(0.55), .purple.opacity(0.32), .blue.opacity(0.22)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                VStack(alignment: .leading, spacing: 8) {
                                    Image(systemName: "sparkles")
                                        .font(.title2)
                                    Text("Liquid Glass")
                                        .font(.title2.bold())
                                    Text("A local material experiment")
                                        .font(.caption)
                                        .opacity(0.75)
                                }
                                .foregroundStyle(.white)
                                .padding(22)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(material.material.opacity(contrast), in: RoundedRectangle(cornerRadius: 18))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(.white.opacity(0.32), lineWidth: 1)
                                }
                                .padding(16)
                            }
                            .frame(height: 170)
                        }

                        FrostbitePanel(title: "Appearance controls", subtitle: "Preview-only settings") {
                            Picker("Material", selection: $material) {
                                ForEach(MaterialChoice.allCases) { item in
                                    Text(item.rawValue).tag(item)
                                }
                            }
                            .pickerStyle(.menu)

                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("Blur simulation")
                                    Spacer()
                                    Text("\(Int(blur))")
                                        .font(.caption.monospaced())
                                        .foregroundStyle(FrostbiteTheme.cyan)
                                }
                                Slider(value: $blur, in: 0...40, step: 1).tint(FrostbiteTheme.cyan)
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("Contrast")
                                    Spacer()
                                    Text("\(Int(contrast * 100))%")
                                        .font(.caption.monospaced())
                                        .foregroundStyle(FrostbiteTheme.cyan)
                                }
                                Slider(value: $contrast, in: 0.1...1, step: 0.01).tint(FrostbiteTheme.cyan)
                            }

                            ColorPicker("Glass tint", selection: $tint, supportsOpacity: false)
                        }

                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "info.circle.fill").foregroundStyle(.orange)
                            Text("This stage changes Frostbite's own SwiftUI preview. It does not modify system-wide Liquid Glass, Control Center, notifications, or SpringBoard.")
                                .font(.caption)
                                .foregroundStyle(FrostbiteTheme.muted)
                        }
                        .padding(14)
                        .background(FrostbiteTheme.panel, in: RoundedRectangle(cornerRadius: 14))
                    }
                    .padding()
                }
            }
            .navigationTitle("Glass")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
