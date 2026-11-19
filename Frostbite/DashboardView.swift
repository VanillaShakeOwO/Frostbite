
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
                    valueRow(
                        "Hardware identifier",
                        report.machineIdentifier
                    )

                    valueRow(
                        "iOS version",
                        report.systemVersion
                    )

                    valueRow(
                        "Build",
                        report.buildVersion
                    )

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
                        "This is a research dashboard only. It does not obtain kernel privileges, bypass platform security, inject tweaks, or install a bootstrap."
                    )
                    .font(.footnote)
                    .foregroundStyle(.secondary)
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
