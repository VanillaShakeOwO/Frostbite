
import Foundation
import SwiftUI

struct GestaltEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var key: String
    var value: String
    var category: String
    var enabled: Bool
    var detail: String
}

enum GestaltPreset: String, CaseIterable, Identifiable {
    case stock = "Stock"
    case dynamicIsland = "Dynamic Island"
    case expandedUI = "Expanded UI"
    case liquidGlass = "Liquid Glass"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .stock:
            return "Start with all catalog entries disabled."
        case .dynamicIsland:
            return "A local Dynamic Island research configuration."
        case .expandedUI:
            return "A local expanded interface research configuration."
        case .liquidGlass:
            return "A local Liquid Glass research configuration."
        }
    }
}

@MainActor
final class GestaltStore: ObservableObject {
    @Published var entries: [GestaltEntry] = [] {
        didSet { save() }
    }

    @Published var selectedPreset: GestaltPreset = .stock {
        didSet {
            UserDefaults.standard.set(
                selectedPreset.rawValue,
                forKey: "frostbite.gestalt.preset"
            )
        }
    }

    private let storageKey = "frostbite.gestalt.entries"

    init() {
        load()
    }

    var enabledCount: Int {
        entries.filter(\.enabled).count
    }

    var categories: [String] {
        Array(Set(entries.map(\.category))).sorted()
    }

    func entries(in category: String) -> [GestaltEntry] {
        entries.filter { $0.category == category }
            .sorted { $0.key.localizedCaseInsensitiveCompare($1.key) == .orderedAscending }
    }

    func update(_ entry: GestaltEntry) {
        guard let index = entries.firstIndex(where: { $0.id == entry.id }) else {
            return
        }
        entries[index] = entry
    }

    func addEntry(
        key: String,
        value: String,
        category: String,
        detail: String
    ) {
        let cleanKey = key.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanKey.isEmpty else { return }

        let entry = GestaltEntry(
            key: cleanKey,
            value: value,
            category: category.isEmpty ? "Custom" : category,
            enabled: false,
            detail: detail.isEmpty
                ? "Custom local configuration entry."
                : detail
        )

        entries.append(entry)
    }

    func delete(_ entry: GestaltEntry) {
        entries.removeAll { $0.id == entry.id }
    }

    func apply(_ preset: GestaltPreset) {
        selectedPreset = preset

        entries = Self.catalog.map { original in
            var item = original

            switch preset {
            case .stock:
                item.enabled = false

            case .dynamicIsland:
                item.enabled = item.category == "Dynamic Island"

            case .expandedUI:
                item.enabled = item.category == "Dynamic Island"
                    || item.category == "Interface"

            case .liquidGlass:
                item.enabled = item.category == "Liquid Glass"
            }

            return item
        }
    }

    func exportJSON() -> String {
        let backup = GestaltBackup(
            version: 1,
            createdAt: Date(),
            preset: selectedPreset.rawValue,
            entries: entries
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        guard let data = try? encoder.encode(backup) else {
            return "{}"
        }

        return String(data: data, encoding: .utf8) ?? "{}"
    }

    func importJSON(_ json: String) throws {
        guard let data = json.data(using: .utf8) else {
            throw GestaltBackupError.invalidText
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let backup = try decoder.decode(GestaltBackup.self, from: data)

        guard backup.version == 1 else {
            throw GestaltBackupError.unsupportedVersion
        }

        entries = backup.entries

        if let preset = GestaltPreset(rawValue: backup.preset) {
            selectedPreset = preset
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else {
            return
        }

        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode([GestaltEntry].self, from: data) {
            entries = saved
        } else {
            entries = Self.catalog
        }

        if let raw = UserDefaults.standard.string(
            forKey: "frostbite.gestalt.preset"
        ), let preset = GestaltPreset(rawValue: raw) {
            selectedPreset = preset
        }
    }

    private static let catalog: [GestaltEntry] = [
        GestaltEntry(
            key: "DynamicIslandCapability",
            value: "Enabled",
            category: "Dynamic Island",
            enabled: false,
            detail: "Research placeholder for Dynamic Island capability behavior."
        ),
        GestaltEntry(
            key: "LiveActivities",
            value: "Enabled",
            category: "Dynamic Island",
            enabled: false,
            detail: "Research placeholder for Live Activities presentation."
        ),
        GestaltEntry(
            key: "IslandExpandedPresentation",
            value: "Enabled",
            category: "Dynamic Island",
            enabled: false,
            detail: "Research placeholder for expanded island presentation."
        ),
        GestaltEntry(
            key: "LiquidGlassAppearance",
            value: "Default",
            category: "Liquid Glass",
            enabled: false,
            detail: "Local appearance preference. Does not modify system materials."
        ),
        GestaltEntry(
            key: "GlassIntensity",
            value: "Standard",
            category: "Liquid Glass",
            enabled: false,
            detail: "Local research value for a future appearance backend."
        ),
        GestaltEntry(
            key: "ControlCenterLayout",
            value: "Default",
            category: "Interface",
            enabled: false,
            detail: "Research placeholder for Control Center layout behavior."
        ),
        GestaltEntry(
            key: "StatusBarCustomization",
            value: "Default",
            category: "Interface",
            enabled: false,
            detail: "Research placeholder for status bar customization."
        ),
        GestaltEntry(
            key: "LockScreenLayout",
            value: "Default",
            category: "Interface",
            enabled: false,
            detail: "Research placeholder for Lock Screen layout behavior."
        )
    ]
}

struct GestaltBackup: Codable {
    let version: Int
    let createdAt: Date
    let preset: String
    let entries: [GestaltEntry]
}

enum GestaltBackupError: LocalizedError {
    case invalidText
    case unsupportedVersion

    var errorDescription: String? {
        switch self {
        case .invalidText:
            return "The backup text could not be read."
        case .unsupportedVersion:
            return "This backup version is not supported."
        }
    }
}
