// Views/AddShortcutView.swift
//
// Purpose: A sheet (modal form) where the user creates a new app shortcut.
// Shows text fields for name, URL scheme, and SF Symbol icon name,
// plus a visual picker grid of common icons.

import SwiftUI

struct AddShortcutView: View {

    /// Access the shared store so we can append the new shortcut.
    @EnvironmentObject var store: ShortcutStore

    /// Dismisses this sheet when the user taps Cancel or Save.
    @Environment(\.dismiss) private var dismiss

    // MARK: - Form State

    @State private var name = ""
    @State private var urlScheme = ""
    @State private var iconName = "star.fill"

    /// True when both required fields have content.
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !urlScheme.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // MARK: - Common SF Symbols
    // A curated set of icons the user can tap to select quickly.
    // They can also type any valid SF Symbol name manually.

    private let commonIcons: [String] = [
        "star.fill", "heart.fill", "gear", "bell.fill",
        "camera.fill", "music.note", "video.fill", "phone.fill",
        "envelope.fill", "message.fill", "safari.fill", "cart.fill",
        "map.fill", "house.fill", "person.fill", "person.crop.rectangle",
        "figure.run", "dumbbell.fill", "gamecontroller.fill", "book.fill",
        "doc.text.fill", "pencil", "paintbrush.fill", "terminal.fill",
        "cloud.fill", "sun.max.fill", "moon.fill", "bolt.fill",
        "flame.fill", "globe", "airplane", "car.fill",
        "leaf.fill", "pawprint.fill", "cup.and.saucer.fill", "fork.knife"
    ]

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Form {

                // ── App Details ──
                Section {
                    TextField("App Name", text: $name)

                    TextField("URL Scheme (e.g. spotify://)", text: $urlScheme)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.URL)
                } header: {
                    Text("App Details")
                } footer: {
                    Text("The URL scheme tells iOS which app to open. It usually looks like appname:// — check the app's documentation if unsure.")
                }

                // ── Icon ──
                Section("Icon") {

                    // Text field + live preview side by side
                    HStack {
                        TextField("SF Symbol name", text: $iconName)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()

                        Spacer()

                        // Live preview — updates as the user types.
                        // If the name is invalid, SF Symbols shows a
                        // "questionmark.square.dashed" fallback.
                        Image(systemName: iconName.isEmpty ? "questionmark.square.dashed" : iconName)
                            .font(.title2)
                            .foregroundStyle(.primary)
                            .frame(width: 40, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(.quaternary)
                            )
                    }

                    // Quick-pick grid of common icons
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 6),
                        spacing: 10
                    ) {
                        ForEach(commonIcons, id: \.self) { icon in
                            Button {
                                iconName = icon
                            } label: {
                                Image(systemName: icon)
                                    .font(.title3)
                                    .frame(width: 36, height: 36)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .fill(iconName == icon
                                                  ? Color.accentColor.opacity(0.2)
                                                  : Color.clear)
                                    )
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(icon)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Add App")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Cancel button — dismisses without saving
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }

                // Save button — disabled until form is valid
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let trimmedName = name.trimmingCharacters(in: .whitespaces)
                        let trimmedScheme = urlScheme.trimmingCharacters(in: .whitespaces)
                        let newShortcut = AppShortcut(
                            name: trimmedName,
                            urlScheme: trimmedScheme,
                            iconName: iconName.isEmpty ? "star.fill" : iconName
                        )
                        store.add(newShortcut)
                        dismiss()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    AddShortcutView()
        .environmentObject(ShortcutStore())
}
