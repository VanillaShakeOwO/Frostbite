import SwiftUI

@main
struct FrostbiteApp: App {
    @StateObject private var gestaltStore = GestaltStore()

    var body: some Scene {
        WindowGroup {
            FrostbiteRootView()
                .environmentObject(gestaltStore)
                .preferredColorScheme(.dark)
        }
    }
}

struct FrostbiteRootView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Home", systemImage: "square.grid.2x2") }

            GestaltWorkbenchView()
                .tabItem { Label("Gestalt", systemImage: "slider.horizontal.3") }

            DynamicIslandStudioView()
                .tabItem { Label("Island", systemImage: "capsule") }

            LiquidGlassStudioView()
                .tabItem { Label("Glass", systemImage: "drop") }

            BackupView()
                .tabItem { Label("Backups", systemImage: "externaldrive") }
        }
        .tint(FrostbiteTheme.cyan)
    }
}
