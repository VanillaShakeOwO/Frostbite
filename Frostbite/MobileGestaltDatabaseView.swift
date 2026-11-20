import SwiftUI

struct MobileGestaltDatabaseView: View {
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var selectedKey: MobileGestaltKey?

    private var categories: [String] {
        ["All"] + Array(Set(MobileGestaltKey.all.map(\.category))).sorted()
    }

    private var filteredKeys: [MobileGestaltKey] {
        MobileGestaltKey.all.filter { key in
            (selectedCategory == "All" || key.category == selectedCategory)
            && (searchText.isEmpty
                || key.name.localizedCaseInsensitiveContains(searchText)
                || key.identifier.localizedCaseInsensitiveContains(searchText)
                || key.category.localizedCaseInsensitiveContains(searchText))
        }
        .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    var body: some View {
        ZStack {
            FrostbiteTheme.backgroundGradient.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        FrostbiteTag(text: "Research reference")
                        Text("MobileGestalt\nkey database.")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("Browse readable key names, mapped identifiers, and first-seen versions.")
                            .font(.subheadline)
                            .foregroundStyle(FrostbiteTheme.muted)
                    }

                    notice

                    HStack(spacing: 9) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(FrostbiteTheme.muted)
                        TextField("Search names or identifiers", text: $searchText)
                            .foregroundStyle(.white)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    }
                    .padding(13)
                    .background(FrostbiteTheme.panel, in: RoundedRectangle(cornerRadius: 13))

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { category in
                                Button {
                                    selectedCategory = category
                                } label: {
                                    Text(category)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(selectedCategory == category ? FrostbiteTheme.background : .white)
                                        .padding(.horizontal, 13)
                                        .padding(.vertical, 9)
                                        .background(selectedCategory == category ? FrostbiteTheme.cyan : FrostbiteTheme.panelLight, in: Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Mapped selectors").font(.headline).foregroundStyle(.white)
                            Spacer()
                            Text("\(filteredKeys.count) RESULTS")
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(FrostbiteTheme.muted)
                        }

                        ForEach(filteredKeys) { key in
                            Button { selectedKey = key } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(alignment: .top) {
                                        Text(key.name)
                                            .font(.system(.subheadline, design: .monospaced).weight(.semibold))
                                            .foregroundStyle(.white)
                                            .multilineTextAlignment(.leading)
                                        Spacer(minLength: 5)
                                        Image(systemName: "chevron.right")
                                            .font(.caption.weight(.bold))
                                            .foregroundStyle(FrostbiteTheme.muted)
                                    }
                                    HStack {
                                        FrostbiteTag(text: key.category)
                                        Spacer()
                                        Text(key.firstSeen)
                                            .font(.caption2.monospaced())
                                            .foregroundStyle(FrostbiteTheme.muted)
                                    }
                                    Text(key.identifier)
                                        .font(.system(size: 11, design: .monospaced))
                                        .foregroundStyle(FrostbiteTheme.cyan)
                                        .lineLimit(1)
                                }
                                .padding(14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(FrostbiteTheme.panel, in: RoundedRectangle(cornerRadius: 15))
                            }
                            .buttonStyle(.plain)
                        }

                        if filteredKeys.isEmpty {
                            Text("No matching keys.")
                                .foregroundStyle(FrostbiteTheme.muted)
                                .padding(.vertical, 20)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("DATA SOURCE")
                            .font(.caption2.weight(.bold))
                            .tracking(1)
                            .foregroundStyle(FrostbiteTheme.muted)
                        Link(destination: MobileGestaltKey.sourceURL) {
                            Label("PoomSmart / MGKeys", systemImage: "arrow.up.right.square")
                                .font(.subheadline.weight(.semibold))
                        }
                        Text("Frostbite's catalog is a small independently authored reference subset. Consult the upstream repository for its license and complete mapping data.")
                            .font(.caption)
                            .foregroundStyle(FrostbiteTheme.muted)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(FrostbiteTheme.panel, in: RoundedRectangle(cornerRadius: 15))
                }
                .padding()
            }
        }
        .navigationTitle("Key Database")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedKey) { key in
            NavigationStack {
                ZStack {
                    FrostbiteTheme.backgroundGradient.ignoresSafeArea()
                    VStack(alignment: .leading, spacing: 18) {
                        FrostbiteTag(text: key.category)
                        Text(key.name)
                            .font(.system(.title3, design: .monospaced).weight(.bold))
                            .foregroundStyle(.white)
                            .textSelection(.enabled)
                        detailRow("Identifier", key.identifier)
                        detailRow("First listed", key.firstSeen)
                        detailRow("Reference baseline", "iOS 27.2")
                        VStack(alignment: .leading, spacing: 7) {
                            Text("Research note").font(.headline).foregroundStyle(.white)
                            Text(key.note).font(.subheadline).foregroundStyle(FrostbiteTheme.muted)
                        }
                        HStack(alignment: .top, spacing: 9) {
                            Image(systemName: "exclamationmark.triangle.fill").foregroundStyle(.orange)
                            Text("This is a mapped identifier, not a verified tweak recipe. Frostbite has not read or changed this value on your device.")
                                .font(.caption)
                                .foregroundStyle(FrostbiteTheme.muted)
                        }
                        .padding(13)
                        .background(FrostbiteTheme.panel, in: RoundedRectangle(cornerRadius: 13))
                        Link(destination: MobileGestaltKey.sourceURL) {
                            Label("Open upstream mapping", systemImage: "arrow.up.right")
                                .font(.subheadline.weight(.semibold))
                        }
                        Spacer()
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .navigationTitle("Key details")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { selectedKey = nil }
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }

    private var notice: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "info.circle.fill").foregroundStyle(FrostbiteTheme.cyan)
            VStack(alignment: .leading, spacing: 5) {
                Text("Mapping data, not write instructions")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                Text("The upstream MGKeys project documents mappings based on iOS 27.2. This database does not confirm behavior on your 27.3 beta build.")
                    .font(.caption)
                    .foregroundStyle(FrostbiteTheme.muted)
            }
        }
        .padding(14)
        .background(FrostbiteTheme.panel, in: RoundedRectangle(cornerRadius: 15))
    }

    private func detailRow(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title.uppercased())
                .font(.caption2.weight(.bold))
                .foregroundStyle(FrostbiteTheme.muted)
            Text(value)
                .font(.system(.subheadline, design: .monospaced))
                .foregroundStyle(.white)
                .textSelection(.enabled)
        }
    }
}
