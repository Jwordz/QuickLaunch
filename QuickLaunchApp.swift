// QuickLaunch/QuickLaunchApp.swift
// Purpose: Main entry point for the QuickLaunch app.
// This file tells iOS where the app starts and what the first screen is.

import SwiftUI

/// The @main attribute marks this as the app's entry point — iOS launches here.
@main
struct QuickLaunchApp: App {

    /// `body` defines the app's scene structure.
    /// A WindowGroup is the standard container for an iOS app's main window.
    var body: some Scene {
        WindowGroup {
            // ContentView is the first screen the user sees when the app opens.
            ContentView()
        }
    }
}
