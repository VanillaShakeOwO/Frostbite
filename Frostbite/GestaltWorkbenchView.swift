
import SwiftUI

struct GestaltWorkbenchView: View {
    @EnvironmentObject private var store: GestaltStore

    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var showingAddEntry = false
    @State private var editingEntry: GestaltEntry?

    private var visibleEntries: [GestaltEntry] {
        store.entries.filter { entry in
            let matchesCategory = selectedCategory == "All"
                || entry.category == selectedCategory

            let matchesSearch = searchText.isEmpty
                || entry.key.localizedCaseInsensitiveContains(searchText)
                || entry.value.localizedCaseInsensitiveContains(searchText)
                || entry.detail.localizedCaseInsensitiveContains(searchText)

            return matchesCategory && matchesSearch
        }
        .sorted {
            $0.key.localizedCaseInsensitiveCompare($1.key) == .orderedAscending
        }
    }

    private var filters: [String] {
        ["All"] + store.categories
    }

    var body: some View {
        NavigationStack {
            ZStack {
                FrostbiteTheme.backgroundGradient
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        header
                        statusPanel
                        presetPanel
                        categoryPicker
                        entriesSection
                        backendNotice
                    }
                    .padding()
                }
            }
            .navigationTitle("Gestalt")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddEntry = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                    }
                }
            }
            .sheet(isPresented: $showingAddEntry) {
                AddGestaltEntryView()
                    .environmentObject(store)
            }
            .sheet(item: $editingEntry) { entry in
                EditGestaltEntryView(entry: entry)
                    .environmentObject(store)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            FrostbiteTag(text: "MobileGestalt workbench")

            Text("Shape your\nconfiguration.")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Manage research profiles and local configuration entries.")
                .font(.subheadline)
                .foregroundStyle(FrostbiteTheme.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var statusPanel: some View {
        FrostbitePanel(
            title: "Configuration status",
            subtitle: "Saved locally on this device"
        ) {
            HStack(spacing: 18) {
                metric(
                    value: "\(store.entries.count)",
                    label: "Entries"
                )

                metric(
                    value: "\(store.enabledCount)",
                    label: "Enabled"
                )

                Spacer()

                FrostbiteTag(
                    text: "Local only",
                    color: .orange
                )
            }

            ProgressView(
                value: store.entries.isEmpty
                    ? 0
                    : Double(store.enabledCount) / Double(store.entries.count)
            )
            .tint(FrostbiteTheme.cyan)
        }
    }

    private func metric(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text(label)
                .font(.caption)
                .foregroundStyle(FrostbiteTheme.muted)
        }
    }

    private var presetPanel: some View {
        FrostbitePanel(
            title: "Configuration presets",
            subtitle: "Choose a starting profile"
        ) {
            VStack(spacing: 9) {
                ForEach(GestaltPreset.allCases) { preset in
                    Button {
                        store.apply(preset)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: presetIcon(preset))
                                .font(.title3)
                                .foregroundStyle(FrostbiteTheme.cyan)
                                .frame(width: 28)

                            VStack(alignment: .leading, spacing: 3) {
                                Text(preset.rawValue)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.white)

                                Text(preset.description)
                                    .font(.caption)
                                    .foregroundStyle(FrostbiteTheme.muted)
                                    .multilineTextAlignment(.leading)
                            }

                            Spacer()

                            if store.selectedPreset == preset {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(FrostbiteTheme.cyan)
                            }
                        }
                        .padding(11)
                        .background(
                            store.selectedPreset == preset
                                ? FrostbiteTheme.cyan.opacity(0.12)
                                : FrostbiteTheme.panelLight,
                            in: RoundedRectangle(cornerRadius: 13)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func presetIcon(_ preset: GestaltPreset) -> String {
        switch preset {
        case .stock: return "arrow.counterclockwise"
        case .dynamicIsland: return "capsule"
        case .expandedUI: return "rectangle.expand.vertical"
        case .liquidGlass: return "drop"
        }
    }

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(filters, id: \.self) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        Text(category)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(
                                selectedCategory == category
                                    ? FrostbiteTheme.background
                                    : .white
                            )
                            .padding(.horizontal, 14)
                            .padding(.vertical, 9)
                            .background(
                                selectedCategory == category
                                    ? FrostbiteTheme.cyan
                                    : FrostbiteTheme.panelLight,
                                in: Capsule()
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var entriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Configuration entries")
                    .font(.headline)
                    .foregroundStyle(.white)

                Spacer()

                Text("\(visibleEntries.count) ITEMS")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(FrostbiteTheme.muted)
            }

            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(FrostbiteTheme.muted)

                TextField("Search keys and values", text: $searchText)
                    .foregroundStyle(.white)
                    .autocorrectionDisabled()
            }
            .padding(12)
            .background(FrostbiteTheme.panel, in: RoundedRectangle(cornerRadius: 12))

            if visibleEntries.isEmpty {
                Text("No matching entries.")
                    .font(.subheadline)
                    .foregroundStyle(FrostbiteTheme.muted)
                    .padding(.vertical, 20)
            } else {
                ForEach(visibleEntries) { entry in
                    GestaltEntryCard(
                        entry: entry,
                        onToggle: { enabled in
                            var updated = entry
                            updated.enabled = enabled
                            store.update(updated)
                        },
                        onEdit: {
                            editingEntry = entry
                        },
                        onDelete: {
                            store.delete(entry)
                        }
                    )
                }
            }
        }
    }

    private var backendNotice: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "info.circle.fill")
                .foregroundStyle(.orange)

            Text(
                "These entries are stored by Frostbite only. Enabling an entry does not change iOS MobileGestalt, system capabilities, or device behavior."
            )
            .font(.caption)
            .foregroundStyle(FrostbiteTheme.muted)
        }
        .padding(14)
        .background(FrostbiteTheme.panel, in: RoundedRectangle(cornerRadius: 14))
    }
}

private struct GestaltEntryCard: View {
    let entry: GestaltEntry
    let onToggle: (Bool) -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(entry.key)
                        .font(.system(.subheadline, design: .monospaced).weight(.semibold))
                        .foregroundStyle(.white)
                        .textSelection(.enabled)

                    FrostbiteTag(text: entry.category)
                }

                Spacer()

                Toggle(
                    "Enabled",
                    isOn: Binding(
                        get: { entry.enabled },
                        set: { onToggle($0) }
                    )
                )
                .labelsHidden()
                .tint(FrostbiteTheme.cyan)
            }

            Text(entry.detail)
                .font(.caption)
                .foregroundStyle(FrostbiteTheme.muted)

            HStack {
                Text("Value: \(entry.value)")
                    .font(.caption.monospaced())
                    .foregroundStyle(FrostbiteTheme.cyan)

                Spacer()

                Button("Edit", action: onEdit)
                    .font(.caption.weight(.semibold))

                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "trash")
                        .font(.caption)
                }
                .padding(.leading, 8)
            }
        }
        .padding(14)
        .background(FrostbiteTheme.panel, in: RoundedRectangle(cornerRadius: 15))
    }
}

private struct AddGestaltEntryView: View {
    @EnvironmentObject private var store: GestaltStore
    @Environment(\.dismiss) private var dismiss

    @State private var key = ""
    @State private var value = ""
    @State private var category = "Custom"
    @State private var detail = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("New entry") {
                    TextField("Key name", text: $key)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    TextField("Value", text: $value)

                    TextField("Category", text: $category)

                    TextField("Description", text: $detail, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section {
                    Text("New entries are saved locally and start disabled.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Add entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        store.addEntry(
                            key: key,
                            value: value,
                            category: category,
                            detail: detail
                        )
                        dismiss()
                    }
                    .disabled(key.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

private struct EditGestaltEntryView: View {
    @EnvironmentObject private var store: GestaltStore
    @Environment(\.dismiss) private var dismiss

    @State private var entry: GestaltEntry

    init(entry: GestaltEntry) {
        _entry = State(initialValue: entry)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Configuration") {
                    TextField("Key", text: $entry.key)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    TextField("Value", text: $entry.value)

                    TextField("Category", text: $entry.category)

                    Toggle("Enabled in Frostbite", isOn: $entry.enabled)
                }

                Section("Description") {
                    TextField("Description", text: $entry.detail, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section {
                    Text("Changes affect Frostbite's local configuration only.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Edit entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.update(entry)
                        dismiss()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
