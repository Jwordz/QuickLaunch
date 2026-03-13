// QuickLaunch/Models/AppShortcut.swift
// Purpose: Data model that represents a single app shortcut.
// Each shortcut stores the info needed to display a row and open the target app.

import Foundation

/// AppShortcut holds everything we need for one launcher entry.
///
/// - Identifiable: lets SwiftUI uniquely identify each item in a list (required by ForEach/List).
/// - Codable: makes it easy to save/load from JSON in the future if needed.
struct AppShortcut: Identifiable, Codable {

    /// A unique identifier for each shortcut — auto-generated.
    let id: UUID

    /// The human-readable name shown in the list, e.g. "Obsidian".
    let name: String

    /// The URL scheme used to deep-link into the target app, e.g. "obsidian://".
    let urlScheme: String

    /// The name of an SF Symbol icon (or a custom asset) to display next to the name.
    let iconName: String

    // MARK: - Convenience Initializer

    /// Creates a new AppShortcut with an auto-generated UUID.
    /// This keeps the call site cleaner — you don't have to pass `id` every time.
    ///
    /// - Parameters:
    ///   - name: Display name of the app.
    ///   - urlScheme: The deep-link URL scheme (including "://").
    ///   - iconName: An SF Symbol name like "star.fill" or a custom asset name.
    init(name: String, urlScheme: String, iconName: String) {
        self.id = UUID()
        self.name = name
        self.urlScheme = urlScheme
        self.iconName = iconName
    }
}
