// QuickLaunchWidget/QuickLaunchHomeWidget.swift
//
// Purpose: A medium-sized Home Screen / Today View widget.
//
// 📖 How is this different from the Lock Screen widget?
// Home Screen widgets (systemSmall/Medium/Large) are bigger and more powerful
// than Lock Screen widgets. The key difference for us:
//
//   ✅ Home Screen widgets support the `Link` view, so EACH shortcut cell
//      can open a DIFFERENT app — unlike Lock Screen widgets where the
//      entire widget is a single tap target.
//
// This widget shows all 5 shortcuts in a 2-column grid.
// Tapping any cell deep-links directly into that app.

import WidgetKit
import SwiftUI

// MARK: - Timeline Entry
// Holds the data for one "frame" of the widget.
// We pass all 5 shortcuts here (not just 3 like the Lock Screen version).

struct HomeWidgetEntry: TimelineEntry {
    let date: Date
    let shortcuts: [AppShortcut]
}

// MARK: - Timeline Provider
// Feeds data to the widget. Since our shortcuts are hardcoded,
// every method returns the same static list.

struct HomeWidgetProvider: TimelineProvider {

    func placeholder(in context: Context) -> HomeWidgetEntry {
        HomeWidgetEntry(date: .now, shortcuts: sampleShortcuts)
    }

    func getSnapshot(in context: Context, completion: @escaping (HomeWidgetEntry) -> Void) {
        completion(HomeWidgetEntry(date: .now, shortcuts: sampleShortcuts))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HomeWidgetEntry>) -> Void) {
        let entry = HomeWidgetEntry(date: .now, shortcuts: sampleShortcuts)
        // .never — our data doesn't change. Change to .after(Date) if you
        // later load shortcuts dynamically.
        completion(Timeline(entries: [entry], policy: .never))
    }
}

// MARK: - Shortcut Cell
// One tappable cell in the grid: large icon on top, app name below.
// Wrapped in a `Link` so tapping opens the target app's URL scheme.

struct ShortcutCell: View {
    let shortcut: AppShortcut

    var body: some View {
        // Link makes this cell independently tappable on Home Screen widgets.
        // ⚠️ If the URL scheme is invalid or the app isn't installed,
        //     iOS silently does nothing — there is no error callback in widgets.
        if let url = URL(string: shortcut.urlScheme) {
            Link(destination: url) {
                cellContent
            }
        } else {
            // Fallback: if the URL scheme string is somehow malformed,
            // show the cell without a link so the layout doesn't break.
            cellContent
        }
    }

    /// The visual content shared by both the Link and fallback paths.
    private var cellContent: some View {
        VStack(spacing: 4) {
            Image(systemName: shortcut.iconName)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.white)

            Text(shortcut.name)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.white.opacity(0.8))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.white.opacity(0.1))
        )
    }
}

// MARK: - Medium Widget View
// 2-column grid showing all 5 shortcuts with a small title at the top.

struct MediumWidgetView: View {
    let entry: HomeWidgetEntry

    /// Two flexible columns with a small gap between them.
    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Widget title — small and subtle so it doesn't steal focus.
            Text("Quick Launch")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.white.opacity(0.5))

            // 2-column grid — 5 items → 3 rows (last row has 1 cell).
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(entry.shortcuts) { shortcut in
                    ShortcutCell(shortcut: shortcut)
                }
            }
        }
    }
}

// MARK: - Widget Definition

struct QuickLaunchHomeWidget: Widget {
    let kind = "QuickLaunchHomeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HomeWidgetProvider()) { entry in
            if #available(iOSApplicationExtension 17.0, *) {
                // iOS 17+: use containerBackground to set the dark background.
                MediumWidgetView(entry: entry)
                    .containerBackground(for: .widget) {
                        Color(red: 0.11, green: 0.11, blue: 0.118) // #1C1C1E
                    }
            } else {
                // iOS 16: apply background + padding directly.
                MediumWidgetView(entry: entry)
                    .padding(12)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.118))
            }
        }
        .configurationDisplayName("Quick Launch")
        .description("Launch your favourite apps from the Home Screen.")
        .supportedFamilies([.systemMedium])
    }
}

// MARK: - Xcode Canvas Previews

#Preview("Medium", as: .systemMedium) {
    QuickLaunchHomeWidget()
} timeline: {
    HomeWidgetEntry(date: .now, shortcuts: sampleShortcuts)
}
