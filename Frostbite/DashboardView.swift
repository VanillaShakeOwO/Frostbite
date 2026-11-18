import SwiftUI

struct DashboardView: View {
    private let report = DeviceReport.current

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
                        Text(report.matchesResearchTarget ? "Exact match" : "Different device/build")
                            .foregroundStyle(report.matchesResearchTarget ? .green : .orange)
                    }
                }

                Section("Jailbreak status") {
                    Label("No verified kernel exploit integrated", systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.orange)
                    Text("This is a research dashboard only. It does not obtain kernel privileges, bypass platform security, inject tweaks, or install a bootstrap.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("Engineering gates") {
                    gate("1", "Verify exact device identifier and board")
                    gate("2", "Find device- and build-specific exploit evidence")
                    gate("3", "Independently reproduce the primitive")
                    gate("4", "Assess mitigation and stability impact")
                    gate("5", "Only then evaluate bootstrap feasibility")
                }
            }
            .navigationTitle("Frostbite")
            .listStyle(.insetGrouped)
        }
    }

    private func valueRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(.secondary)
                .textSelection(.enabled)
        }
    }

    private func gate(_ number: String, _ detail: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number).font(.headline).foregroundStyle(.secondary)
            Text(detail)
        }
    }
}
