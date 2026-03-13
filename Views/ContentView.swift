// QuickLaunch/Views/ContentView.swift
// Purpose: The main screen of the app.
// Shows a list of app shortcuts with drag-to-reorder, swipe-to-delete,
// and an Add button to create new shortcuts.

import SwiftUI

struct ContentView: View {

    /// The shared store injected by QuickLaunchApp via .environmentObject.
    @EnvironmentObject var store: ShortcutStore

    /// Opens URLs (used to launch other apps via their URL schemes).
    @Environment(\.openURL) private var openURL

    /// Controls whether the "Add App" sheet is showing.
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            Group {
                if store.shortcuts.isEmpty {
                    // Empty state — shown when the user has deleted all shortcuts.
                    ContentUnavailableView {
                        Label("No Shortcuts", systemImage: "app.dashed")
                    } description: {
                        Text("Tap + to add your first app shortcut.")
                    }
                } else {
                    // Main list — supports drag-to-reorder and swipe-to-delete.
                    List {
                        ForEach(store.shortcuts) { shortcut in
                            Button {
                                openApp(shortcut: shortcut)
                            } label: {
                                ShortcutRowView(shortcut: shortcut)
                            }
                            .buttonStyle(.plain)
                        }
                        // .onMove enables drag-and-drop reordering in edit mode.
                        .onMove { store.move(from: $0, to: $1) }
                        // .onDelete enables the swipe-left-to-delete gesture.
                        .onDelete { store.delete(at: $0) }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("QuickLaunch")
            .toolbar {
                // Edit button — toggles edit mode (shows drag handles + delete buttons)
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                // Add button — opens the Add App sheet
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddShortcutView()
                    .environmentObject(store)
            }
        }
    }

    // MARK: - Actions

    /// Opens the target app using its URL scheme.
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

// MARK: - Preview

#Preview {
    ContentView()
        .environmentObject(ShortcutStore())
}
