// QuickLaunch/QuickLaunchApp.swift
// Purpose: Main entry point for the QuickLaunch app.
// Creates the ShortcutStore and injects it into the view hierarchy.

import SwiftUI

/// The @main attribute marks this as the app's entry point — iOS launches here.
@main
struct QuickLaunchApp: App {

    /// Create the store once here. It lives for the entire app lifecycle.
    /// @StateObject ensures SwiftUI creates it only once and keeps it alive.
    @StateObject private var store = ShortcutStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                // Inject the store so every child view can access it
                // via @EnvironmentObject var store: ShortcutStore
                .environmentObject(store)
        }
    }
}
