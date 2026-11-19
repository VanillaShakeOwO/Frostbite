
import SwiftUI

struct DashboardView: View {
    private let report = DeviceReport.current

    private var researchStatusColor: Color {
        switch report.matchesResearchTarget {
        case .some(true):
            return .green
        case .some(false):
            return .orange
        case .none:
            return .secondary
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Detected device") {
                    valueRow("Hardware identifier", report.machineIdentifier)
                    valueRow("iOS version", report.systemVersion)
                    valueRow("Build", report.buildVersion)

                    HStack {
                        Text("Research target")
                        Spacer()
                        Text(report.researchTargetStatus)
                            .foregroundStyle(researchStatusColor)
                            .fontWeight(.medium)
                    }
                }

                Section("Jailbreak status") {
                    Label(
                        "No verified kernel exploit integrated",
                        systemImage: "exclamationmark.triangle"
                    )
                    .foregroundStyle(.orange)

                    Text(
                        "Frostbite is currently a research dashboard. It does not obtain kernel privileges, bypass platform security, inject tweaks, or install a bootstrap."
                    )
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }

                // MARK: - Sandbox Escape Research

                Section("Sandbox escape research") {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Label(
                                "worse_query",
                                systemImage: "lock.open"
                            )
                            .font(.headline)

                            Spacer()

                            Text("Build supported")
                                .font(.caption)
                                .foregroundStyle(.green)
                        }

                        Text("Erosion")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text(
                            "A sandbox escape used by Erosion for iOS customization. It is not a kernel exploit or a full jailbreak."
                        )
                        .font(.footnote)

                        Divider()

                        valueRow("Target iOS", "27.3 beta 1")
                        valueRow("Target build", "24C5037i")
                        valueRow("Your build", report.buildVersion)

                        HStack {
                            Text("Build compatibility")

                            Spacer()

                            Text(
                                report.buildVersion == "24C5037i"
                                ? "Listed as supported"
                                : "Not confirmed"
                            )
                            .foregroundStyle(
                                report.buildVersion == "24C5037i"
                                ? .green : .orange
                            )
                        }

                        Text(
                            "Erosion lists iOS 27.3 beta 1 as supported. Its documentation identifies beta 2 (24C5049d) as patched. This is build-level evidence, not independent testing of every device model."
                        )
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                        Divider()

                        Link(
                            destination: URL(
                                string: "https://github.com/jailbreakdotparty/Erosion"
                            )!
                        ) {
                            Label(
                                "Erosion source repository",
                                systemImage: "arrow.up.right.square"
                            )
                        }

                        Link(
                            destination: URL(
                                string: "https://github.com/forcequitOS/worse_query"
                            )!
                        ) {
                            Label(
                                "worse_query original PoC",
                                systemImage: "arrow.up.right.square"
                            )
                        }
                    }
                    .padding(.vertical, 6)
                }

                Section("Engineering gates") {
                    gate("1", "Verify exact device identifier and board")
                    gate("2", "Find device- and build-specific exploit evidence")
                    gate("3", "Independently reproduce the primitive")
                    gate("4", "Assess mitigation and stability impact")
                    gate("5", "Evaluate bootstrap feasibility only after validation")
                }

                Section("Hardware reference profile") {
                    valueRow("Board configuration", "V159AP")
                    valueRow("Board ID", "0x16")
                    valueRow("Chip ID", "0x8150")
                    valueRow("Platform", "t8150")
                    valueRow("Architecture", "arm64e")

                    Text(
                        "These are externally supplied research references, not values detected by Frostbite."
                    )
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Frostbite")
            .listStyle(.insetGrouped)
        }
    }

    private func valueRow(
        _ title: String,
        _ value: String
    ) -> some View {
        HStack {
            Text(title)

            Spacer()

            Text(value)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(.secondary)
                .textSelection(.enabled)
        }
    }

    private func gate(
        _ number: String,
        _ detail: String
    ) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(detail)
        }
    }
}
