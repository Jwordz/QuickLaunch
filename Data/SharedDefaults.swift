// Data/SharedDefaults.swift
//
// Purpose: Constants and helper shared between the main app and widget extension.
//
// 📖 What is an App Group?
// By default, each app and its extensions have separate, sandboxed storage.
// An App Group creates a SHARED container that both the main app and the
// widget extension can read from and write to.
//
// The App Group ID must match EXACTLY in:
//   1. This file (the string below)
//   2. The main app's .entitlements file
//   3. The widget extension's .entitlements file
//   4. The App Group registered in your Apple Developer account
//
// If any of these don't match, the widget won't see saved shortcuts.

import Foundation

// MARK: - Shared Constants

/// The App Group identifier — used to create a shared UserDefaults container.
/// Both the main app and the widget read/write to this same store.
let appGroupID = "group.com.FamiliaDJ.QuickLaunch"

/// The UserDefaults key where we store the JSON-encoded shortcut array.
let shortcutsKey = "savedShortcuts"

// MARK: - Shared Loading Function

/// Loads shortcuts from the shared App Group container.
///
/// This is called by:
///   - The main app's ShortcutStore (on launch)
///   - The widget's timeline providers (every time the widget refreshes)
///
/// If nothing has been saved yet (first launch) or the data is corrupt,
/// it falls back to the hardcoded default list in ShortcutData.swift.
///
/// - Returns: An array of AppShortcut, either from storage or the default list.
func loadSharedShortcuts() -> [AppShortcut] {
    // Try to open the shared UserDefaults container.
    guard let defaults = UserDefaults(suiteName: appGroupID) else {
        // If the App Group isn't configured yet, fall back to defaults.
        return sampleShortcuts
    }

    // Try to read the saved JSON data.
    guard let data = defaults.data(forKey: shortcutsKey) else {
        // No data saved yet (first launch) — return the default list.
        return sampleShortcuts
    }

    // Try to decode the JSON into an array of AppShortcut.
    guard let decoded = try? JSONDecoder().decode([AppShortcut].self, from: data) else {
        // Data exists but is corrupt — fall back to defaults.
        return sampleShortcuts
    }

    return decoded
}

/// Saves shortcuts to the shared App Group container.
/// Called by the main app's ShortcutStore after every change.
///
/// - Parameter shortcuts: The array to persist.
func saveSharedShortcuts(_ shortcuts: [AppShortcut]) {
    guard let defaults = UserDefaults(suiteName: appGroupID) else { return }
    if let data = try? JSONEncoder().encode(shortcuts) {
        defaults.set(data, forKey: shortcutsKey)
    }
}
