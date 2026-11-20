
import SwiftUI

struct BackupView: View {
    @EnvironmentObject private var store: GestaltStore

    @State private var importText = ""
    @State private var statusMessage: String?
    @State private var showingImport = false

    var body: some View {
        NavigationStack {
            ZStack {
                FrostbiteTheme.backgroundGradient
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            FrostbiteTag(text: "Configuration safety")

                            Text("Back it up.")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)

                            Text("Export or restore your Frostbite configuration.")
                                .font(.subheadline)
                                .foregroundStyle(FrostbiteTheme.muted)
                        }

                        FrostbitePanel(
                            title: "Current configuration",
                            subtitle: "Stored locally by Frostbite"
                        ) {
                            backupRow("Total entries", "\(store.entries.count)")
                            backupRow("Enabled entries", "\(store.enabledCount)")
                            backupRow("Selected preset", store.selectedPreset.rawValue)

                            ShareLink(
                                item: store.exportJSON(),
                                subject: Text("Frostbite Gestalt Backup"),
                                preview: SharePreview("Frostbite configuration.json")
                            ) {
                                Label("Export JSON backup", systemImage: "square.and.arrow.up")
                                    .font(.subheadline.weight(.semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(13)
                                    .background(
                                        FrostbiteTheme.cyan,
                                        in: RoundedRectangle(cornerRadius: 12)
                                    )
                                    .foregroundStyle(FrostbiteTheme.background)
                            }
                        }

                        FrostbitePanel(
                            title: "Restore configuration",
                            subtitle: "Paste a previously exported Frostbite JSON backup"
                        ) {
                            Button {
                                showingImport = true
                            } label: {
                                Label("Import JSON backup", systemImage: "square.and.arrow.down")
                                    .font(.subheadline.weight(.semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(13)
                                    .background(
                                        FrostbiteTheme.panelLight,
                                        in: RoundedRectangle(cornerRadius: 12)
                                    )
                            }

                            if let statusMessage {
                                Text(statusMessage)
                                    .font(.caption)
                                    .foregroundStyle(FrostbiteTheme.cyan)
                            }
                        }

                        FrostbitePanel(
                            title: "Backup notes",
                            subtitle: "What this backup contains"
                        ) {
                            Text(
                                "The backup contains Frostbite's local entry names, values, categories, enabled states, and selected preset. It does not contain or restore actual iOS MobileGestalt settings."
                            )
                            .font(.caption)
                            .foregroundStyle(FrostbiteTheme.muted)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Backups")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingImport) {
                importSheet
            }
        }
    }

    private func backupRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(FrostbiteTheme.muted)

            Spacer()

            Text(value)
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.white)
        }
    }

    private var importSheet: some View {
        NavigationStack {
            Form {
                Section("Backup JSON") {
                    TextEditor(text: $importText)
                        .font(.system(.caption, design: .monospaced))
                        .frame(minHeight: 240)
                }

                Section {
                    Text("Importing replaces the current local Frostbite entries.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Import backup")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingImport = false
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Restore") {
                        do {
                            try store.importJSON(importText)
                            statusMessage = "Backup restored successfully."
                            showingImport = false
                        } catch {
                            statusMessage = error.localizedDescription
                        }
                    }
                    .disabled(importText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
