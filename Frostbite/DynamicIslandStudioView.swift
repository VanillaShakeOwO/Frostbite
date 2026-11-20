import SwiftUI

struct DynamicIslandStudioView: View {
    @State private var xOffset = 0.0
    @State private var yOffset = 0.0
    @State private var axis: AxisChoice = .both

    private enum AxisChoice: String, CaseIterable, Identifiable {
        case horizontal = "X axis"
        case vertical = "Y axis"
        case both = "X + Y"
        var id: String { rawValue }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                FrostbiteTheme.backgroundGradient.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            FrostbiteTag(text: "Dynamic Island Studio")
                            Text("Position your
preview.")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            Text("Experiment with X/Y offsets and axis behavior.")
                                .font(.subheadline)
                                .foregroundStyle(FrostbiteTheme.muted)
                        }

                        FrostbitePanel(title: "Live preview", subtitle: "Frostbite canvas only — not SpringBoard") {
                            GeometryReader { proxy in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 22)
                                        .fill(Color.black.opacity(0.35))
                                    Capsule()
                                        .fill(Color.black)
                                        .frame(width: 126, height: 36)
                                        .overlay {
                                            HStack(spacing: 6) {
                                                Circle().fill(.green).frame(width: 6, height: 6)
                                                Capsule().fill(.white.opacity(0.16)).frame(width: 24, height: 4)
                                            }
                                        }
                                        .offset(x: axis == .vertical ? 0 : xOffset,
                                                y: axis == .horizontal ? 0 : yOffset)
                                    VStack {
                                        Spacer()
                                        Text("Preview area")
                                            .font(.caption2)
                                            .foregroundStyle(.white.opacity(0.35))
                                            .padding(.bottom, 12)
                                    }
                                }
                                .frame(width: proxy.size.width, height: proxy.size.height)
                            }
                            .frame(height: 190)
                        }

                        FrostbitePanel(title: "Axis controls", subtitle: "Adjust offsets in points") {
                            Picker("Axis", selection: $axis) {
                                ForEach(AxisChoice.allCases) { choice in
                                    Text(choice.rawValue).tag(choice)
                                }
                            }
                            .pickerStyle(.segmented)

                            valueSlider("X offset", value: $xOffset)
                            valueSlider("Y offset", value: $yOffset)

                            Button {
                                xOffset = 0
                                yOffset = 0
                                axis = .both
                            } label: {
                                Label("Reset preview", systemImage: "arrow.counterclockwise")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .tint(FrostbiteTheme.cyan)
                        }

                        notice
                    }
                    .padding()
                }
            }
            .navigationTitle("Island")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func valueSlider(_ title: String, value: Binding<Double>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title).foregroundStyle(.white)
                Spacer()
                Text("\(Int(value.wrappedValue)) pt")
                    .font(.caption.monospaced())
                    .foregroundStyle(FrostbiteTheme.cyan)
            }
            Slider(value: value, in: -80...80, step: 1)
                .tint(FrostbiteTheme.cyan)
        }
    }

    private var notice: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "info.circle.fill").foregroundStyle(.orange)
            Text("These controls currently move only the preview inside Frostbite. A real Dynamic Island position change needs a verified SpringBoard/system-layout mechanism; MobileGestalt flags alone do not provide arbitrary X/Y positioning.")
                .font(.caption)
                .foregroundStyle(FrostbiteTheme.muted)
        }
        .padding(14)
        .background(FrostbiteTheme.panel, in: RoundedRectangle(cornerRadius: 14))
    }
}
