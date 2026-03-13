// QuickLaunch/Views/ContentView.swift
// Purpose: The main screen of the app.
// Shows a clean, editorial-style list of app shortcuts.

import SwiftUI

struct ContentView: View {

    let shortcuts: [AppShortcut] = sampleShortcuts
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Header
            // Custom title area with an editorial serif font.
            VStack(spacing: 6) {
                Text("QuickLaunch")
                    .font(.system(.largeTitle, design: .serif))
                    .fontWeight(.bold)
                    .tracking(0.5)

                // Thin decorative rule under the title
                Rectangle()
                    .frame(width: 32, height: 2)
                    .foregroundStyle(.primary)
            }
            .padding(.top, 56)
            .padding(.bottom, 36)

            // MARK: - Shortcut List
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(shortcuts) { shortcut in
                        Button {
                            openApp(shortcut: shortcut)
                        } label: {
                            ShortcutRowView(shortcut: shortcut)
                        }
                        .buttonStyle(ShortcutButtonStyle())
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }

    // MARK: - Actions

    private func openApp(shortcut: AppShortcut) {
        guard let url = URL(string: shortcut.urlScheme) else {
            print("⚠️ Invalid URL scheme: \(shortcut.urlScheme)")
            return
        }
        openURL(url) { success in
            if !success {
                print("⚠️ Could not open \(shortcut.name). Is it installed?")
            }
        }
    }
}

// MARK: - Custom Button Style
// Gives a subtle fade when the user presses a row.

struct ShortcutButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.4 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
