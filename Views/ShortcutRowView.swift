// QuickLaunch/Views/ShortcutRowView.swift
// Purpose: A single row in the shortcut list.
// Shows a small SF Symbol icon and the app name.

import SwiftUI

struct ShortcutRowView: View {

    let shortcut: AppShortcut

    var body: some View {
        HStack(spacing: 14) {
            // App icon — small and muted so the name stays prominent
            Image(systemName: shortcut.iconName)
                .font(.title3)
                .foregroundStyle(.secondary)
                .frame(width: 28)

            // App name in a clean serif font
            Text(shortcut.name)
                .font(.system(.title3, design: .serif))
                .fontWeight(.medium)
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Preview

#Preview {
    List {
        ShortcutRowView(shortcut: AppShortcut(
            name: "Obsidian",
            urlScheme: "obsidian://",
            iconName: "doc.text.fill"
        ))
        ShortcutRowView(shortcut: AppShortcut(
            name: "GYMBOX",
            urlScheme: "gymbox://",
            iconName: "dumbbell.fill"
        ))
    }
}
