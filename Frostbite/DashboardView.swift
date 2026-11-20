
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var store: GestaltStore

    private let report = DeviceReport.current

    private var deviceStatusColor: Color {
        switch report.matchesResearchTarget {
        case .some(true): return .green
        case .some(false): return .orange
        case .none: return FrostbiteTheme.muted
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                FrostbiteTheme.backgroundGradient
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        hero
                        quickStats
                        devicePanel
                        researchPanel
                        hardwarePanel
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "snowflake")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundStyle(FrostbiteTheme.cyan)

                Text("FROSTBITE")
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .tracking(3)
                    .foregroundStyle(.white)

                Spacer()

                FrostbiteTag(text: "Research build")
            }

            Text("Your device.\nYour configuration.")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("An experimental iOS customization workbench.")
                .font(.subheadline)
                .foregroundStyle(FrostbiteTheme.muted)
        }
        .padding(.vertical, 12)
    }

    private var quickStats: some View {
        HStack(spacing: 10) {
            statCard(
                title: "GESTALT",
                value: "\(store.entries.count)",
                subtitle: "Local entries",
                icon: "slider.horizontal.3"
            )

            statCard(
                title: "ACTIVE",
                value: "\(store.enabledCount)",
                subtitle: "Local toggles",
                icon: "switch.2"
            )
        }
    }

    private func statCard(
        title: String,
        value: String,
        subtitle: String,
        icon: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            Image(systemName: icon)
                .foregroundStyle(FrostbiteTheme.cyan)

            Text(value)
                .font(.system(size: 27, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text(title)
                .font(.caption2.weight(.bold))
                .tracking(1)
                .foregroundStyle(FrostbiteTheme.muted)

            Text(subtitle)
                .font(.caption2)
                .foregroundStyle(FrostbiteTheme.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(FrostbiteTheme.panel, in: RoundedRectangle(cornerRadius: 17))
    }

    private var devicePanel: some View {
        FrostbitePanel(
            title: "Detected device",
            subtitle: "Values read from this device"
        ) {
            deviceRow("Hardware", report.machineIdentifier)
            deviceRow("iOS version", report.systemVersion)
            deviceRow("Build", report.buildVersion)

            Divider().overlay(.white.opacity(0.08))

            HStack {
                Text("Research target")

                Spacer()

                Text(report.researchTargetStatus)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(deviceStatusColor)
            }
        }
    }

    private var researchPanel: some View {
        FrostbitePanel(
            title: "Research environment",
            subtitle: "Exploit and backend status"
        ) {
            HStack(spacing: 10) {
                Image(systemName: "lock.shield")
                    .font(.title2)
                    .foregroundStyle(.orange)

                VStack(alignment: .leading, spacing: 4) {
                    Text("No exploit backend connected")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)

                    Text("No kernel privileges or system-level write access.")
                        .font(.caption)
                        .foregroundStyle(FrostbiteTheme.muted)
                }
            }

            Divider().overlay(.white.opacity(0.08))

            Link(
                destination: URL(string: "https://github.com/0xDenji-Ai/erosion")!
            ) {
                Label("Erosion research repository", systemImage: "arrow.up.right")
                    .font(.caption.weight(.semibold))
            }

            Link(
                destination: URL(string: "https://github.com/forcequitOS/worse_query")!
            ) {
                Label("worse_query research repository", systemImage: "arrow.up.right")
                    .font(.caption.weight(.semibold))
            }
        }
    }

    private var hardwarePanel: some View {
        FrostbitePanel(
            title: "Hardware reference",
            subtitle: "Research reference values, not detected values"
        ) {
            deviceRow("Board", "V159AP")
            deviceRow("Board ID", "0x16")
            deviceRow("Chip ID", "0x8150")
            deviceRow("Platform", "t8150")
            deviceRow("Architecture", "arm64e")
        }
    }

    private func deviceRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(FrostbiteTheme.muted)

            Spacer()

            Text(value)
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.white)
                .textSelection(.enabled)
        }
    }
}
