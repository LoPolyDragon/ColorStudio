import SwiftUI

@main
struct ColorStudioApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 900, minHeight: 600)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Palette") {
                    NotificationCenter.default.post(name: NSNotification.Name("CreateNewPalette"), object: nil)
                }
                .keyboardShortcut("n", modifiers: .command)
            }

            CommandGroup(after: .toolbar) {
                Button("Pick Screen Color") {
                    NotificationCenter.default.post(name: NSNotification.Name("PickScreenColor"), object: nil)
                }
                .keyboardShortcut("p", modifiers: [.command, .shift])

                Divider()

                Button("Accessibility Checker") {
                    NotificationCenter.default.post(name: NSNotification.Name("ShowAccessibility"), object: nil)
                }
                .keyboardShortcut("a", modifiers: [.command, .shift])
            }
        }

        Settings {
            SettingsView()
        }
    }
}

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }

            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
        .frame(width: 500, height: 300)
    }
}

struct GeneralSettingsView: View {
    var body: some View {
        Form {
            Section {
                Text("ColorStudio Professional")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Version 1.0.0")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

struct AboutView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "paintpalette.fill")
                .font(.system(size: 64))
                .foregroundColor(.accentColor)

            Text("ColorStudio")
                .font(.title)
                .fontWeight(.bold)

            Text("Professional Color Palette Creator")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("Version 1.0.0")
                .font(.caption)
                .foregroundColor(.secondary)

            Divider()
                .padding(.vertical)

            VStack(alignment: .leading, spacing: 8) {
                Text("Features:")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 4) {
                    Text("• Advanced color picker with wheel and sliders")
                    Text("• Extract colors from images")
                    Text("• Generate color harmonies")
                    Text("• WCAG accessibility checker")
                    Text("• Color blindness simulator")
                    Text("• Export to multiple formats")
                    Text("• Menu bar color picker")
                    Text("• Organize palettes in collections")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }

            Spacer()

            Text("Copyright © 2026 lopoDragon. All rights reserved.")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
