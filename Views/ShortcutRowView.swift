// QuickLaunch/Views/ShortcutRowView.swift
// Purpose: A single row in the shortcut list.
// Clean, editorial design — centred serif text, no chrome.

import SwiftUI

struct ShortcutRowView: View {

    let shortcut: AppShortcut

    var body: some View {
        Text(shortcut.name)
            .font(.system(.title2, design: .serif))
            .fontWeight(.medium)
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity)         // Centre the text horizontally
            .padding(.vertical, 18)
            .contentShape(Rectangle())          // Full row is tappable
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 0) {
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
    .padding()
}
