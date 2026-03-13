// Data/ShortcutStore.swift
//
// Purpose: The single source of truth for the shortcut list in the main app.
//
// 📖 What is an ObservableObject?
// It's a class that SwiftUI watches for changes. When any @Published
// property changes, every view using this object re-renders automatically.
// Think of it as a "live data container" that your views subscribe to.

import Combine     // Needed for ObservableObject and @Published
import Foundation
import SwiftUI     // Needed for collection helpers (remove/move atOffsets)
import WidgetKit   // Needed for WidgetCenter.shared.reloadAllTimelines()

// MARK: - ShortcutStore

class ShortcutStore: ObservableObject {

    /// The live list of shortcuts. @Published means SwiftUI re-renders views
    /// whenever this array changes (add, delete, reorder).
    @Published var shortcuts: [AppShortcut]

    // MARK: - Init

    /// On creation, load shortcuts from the shared App Group storage.
    /// If nothing has been saved yet, this returns the default list.
    init() {
        self.shortcuts = loadSharedShortcuts()
    }

    // MARK: - Mutations
    // Every method that changes the list calls save() at the end,
    // which persists to disk and tells the widget to refresh.

    /// Adds a new shortcut to the end of the list.
    func add(_ shortcut: AppShortcut) {
        shortcuts.append(shortcut)
        save()
    }

    /// Deletes shortcuts at the given index positions.
    /// Called automatically by SwiftUI's swipe-to-delete gesture.
    func delete(at offsets: IndexSet) {
        shortcuts.remove(atOffsets: offsets)
        save()
    }

    /// Moves shortcuts from one position to another.
    /// Called automatically by SwiftUI's drag-and-drop in edit mode.
    func move(from source: IndexSet, to destination: Int) {
        shortcuts.move(fromOffsets: source, toOffset: destination)
        save()
    }

    // MARK: - Persistence

    /// Saves the current list to the shared App Group UserDefaults
    /// and tells all widgets to reload their timelines.
    func save() {
        // Write the JSON to the shared container.
        saveSharedShortcuts(shortcuts)

        // Tell WidgetKit to refresh ALL widgets in our bundle.
        // Without this call, the widget would keep showing stale data
        // until the system decides to refresh it on its own schedule.
        WidgetCenter.shared.reloadAllTimelines()
    }
}
