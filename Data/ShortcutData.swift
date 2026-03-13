// QuickLaunch/Data/ShortcutData.swift
// Purpose: Hardcoded list of app shortcuts displayed in the launcher.
// Edit this file to add, remove, or reorder your shortcuts.

import Foundation

/// A static list of all the apps you want in your launcher.
/// Each entry uses an SF Symbol as a placeholder icon.
///
/// ⚠️  URL Scheme Note:
/// The URL schemes below are *assumed* based on common naming conventions.
/// If tapping a shortcut does nothing, the scheme may be wrong for your device.
/// To find the real scheme:
///   1. Check the app's official documentation.
///   2. Search the app's .plist inside its .ipa (advanced).
///   3. Ask the developer or search online for "<AppName> URL scheme iOS".
///
/// Known-good schemes are marked; the rest are best guesses.
let sampleShortcuts: [AppShortcut] = [

    AppShortcut(
        name: "TagminTalent",
        urlScheme: "tagmintalent://",       // ⚠️ Assumed — verify on your device
        iconName: "person.crop.rectangle"   // SF Symbol: badge/profile card
    ),

    AppShortcut(
        name: "My Workout Plan",
        urlScheme: "myworkoutplan://",       // ⚠️ Assumed — verify on your device
        iconName: "figure.run"              // SF Symbol: running figure
    ),

    AppShortcut(
        name: "GYMBOX",
        urlScheme: "gymbox://",             // ⚠️ Assumed — verify on your device
        iconName: "dumbbell.fill"           // SF Symbol: dumbbell
    ),

    AppShortcut(
        name: "Delta",
        urlScheme: "delta://",              // ⚠️ Assumed — verify on your device
        iconName: "gamecontroller.fill"     // SF Symbol: game controller
    ),

    AppShortcut(
        name: "Obsidian",
        urlScheme: "obsidian://",           // ✅ Documented: https://help.obsidian.md/Advanced+topics/Using+obsidian+URI
        iconName: "doc.text.fill"           // SF Symbol: document
    )
]
