// QuickLaunchWidget/QuickLaunchWidget.swift
//
// Purpose: Defines the Lock Screen widget for QuickLaunch.
//
// 📖 What is a Lock Screen Widget?
// Starting with iOS 16, you can add small "accessory" widgets to the
// Lock Screen (and the Apple Watch). They come in a few shapes:
//
//   • .accessoryCircular    — a small circle (like a watch complication)
//   • .accessoryRectangular — a wider rectangle that can show more info
//   • .accessoryInline      — a single line of text beside the clock
//
// This widget supports circular and rectangular.
//
// ⚠️ IMPORTANT LIMITATION:
// Lock Screen widgets are NOT interactive in the way a normal app is.
// You CANNOT have separate "buttons" that each do something different.
// The ENTIRE widget is a single tap target — when the user taps anywhere
// on the widget, iOS opens ONE URL that you set via `widgetURL`.
//
// On Home Screen widgets (systemMedium/Large), you can use `Link` views
// to create multiple tappable regions — but that does NOT work for
// Lock Screen (accessory-family) widgets on iOS 16 or 17.
//
// So our approach is:
//   • Circular widget  → tapping opens the FIRST shortcut's app.
//   • Rectangular widget → visually shows 3 shortcuts, but tapping
//     opens the QuickLaunch app so the user can pick one.

import WidgetKit
import SwiftUI

// MARK: - Timeline Entry
// A TimelineEntry represents one "snapshot" of data the widget should display.
// Because our shortcut list is static, we only ever need one entry.

struct LockScreenEntry: TimelineEntry {
    /// WidgetKit requires a date — it uses this to schedule refreshes.
    let date: Date

    /// The shortcuts to display (we'll grab the first 3).
    let shortcuts: [AppShortcut]
}

// MARK: - Timeline Provider
// The provider tells WidgetKit what data to show and when to refresh.

struct LockScreenProvider: TimelineProvider {

    /// Placeholder: shown while the widget is loading for the first time.
    /// Use realistic sample data so the layout looks correct.
    func placeholder(in context: Context) -> LockScreenEntry {
        LockScreenEntry(
            date: .now,
            shortcuts: Array(loadSharedShortcuts().prefix(3))
        )
    }

    /// Snapshot: used for the widget gallery (when the user is choosing widgets).
    /// Should return quickly with representative data.
    func getSnapshot(in context: Context, completion: @escaping (LockScreenEntry) -> Void) {
        let entry = LockScreenEntry(
            date: .now,
            shortcuts: Array(loadSharedShortcuts().prefix(3))
        )
        completion(entry)
    }

    /// Timeline: the main data source. Returns an array of entries and a refresh policy.
    /// Reads from the shared App Group so it reflects user changes.
    func getTimeline(in context: Context, completion: @escaping (Timeline<LockScreenEntry>) -> Void) {
        let entry = LockScreenEntry(
            date: .now,
            shortcuts: Array(loadSharedShortcuts().prefix(3))
        )
        // .never means WidgetKit won't ask for new data automatically.
        // If you later load shortcuts from a database, change this to
        // .after(Date) to refresh periodically.
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

// MARK: - Circular Widget View
// Shows the first shortcut's icon inside a small circle.
// Tapping opens that app directly via its URL scheme.

struct CircularWidgetView: View {
    let entry: LockScreenEntry

    var body: some View {
        if let first = entry.shortcuts.first {
            ZStack {
                // AccessoryWidgetBackground provides the standard
                // translucent circular background for Lock Screen widgets.
                AccessoryWidgetBackground()

                Image(systemName: first.iconName)
                    .font(.title2)
                    // widgetAccentable() lets iOS tint the icon to match
                    // the user's chosen Lock Screen colour theme.
                    .widgetAccentable()
            }
            // widgetURL sets the URL opened when the user taps the widget.
            // For the circular widget we open the first shortcut's app.
            .widgetURL(URL(string: first.urlScheme))
        }
    }
}

// MARK: - Rectangular Widget View
// Shows up to 3 shortcuts side by side with icons and labels.
// Tapping opens the QuickLaunch app (because Lock Screen widgets
// only support a single tap target — see the note at the top of this file).

struct RectangularWidgetView: View {
    let entry: LockScreenEntry

    var body: some View {
        HStack(spacing: 6) {
            ForEach(entry.shortcuts.prefix(3)) { shortcut in
                VStack(spacing: 2) {
                    Image(systemName: shortcut.iconName)
                        .font(.body)
                        .widgetAccentable()

                    Text(shortcut.name)
                        .font(.system(size: 8))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                .frame(maxWidth: .infinity)
            }
        }
        // Opens the first shortcut's app when tapped.
        // If you'd rather open the main QuickLaunch app, change this to:
        //   .widgetURL(URL(string: "quicklaunch://"))
        // (You'd also need to register "quicklaunch" as a URL scheme in Info.plist.)
        .widgetURL(URL(string: entry.shortcuts.first?.urlScheme ?? ""))
    }
}

// MARK: - Entry View (routes to the correct layout)
// WidgetKit calls this view for every timeline entry.
// We check which widget family (size) the user picked and show the right layout.

struct LockScreenWidgetEntryView: View {
    /// The widget family tells us which size the user added.
    @Environment(\.widgetFamily) var family

    let entry: LockScreenEntry

    var body: some View {
        switch family {
        case .accessoryCircular:
            CircularWidgetView(entry: entry)
        case .accessoryRectangular:
            RectangularWidgetView(entry: entry)
        default:
            // Safety net — shouldn't happen because we only advertise two families.
            Text("QuickLaunch")
        }
    }
}

// MARK: - Widget Definition
// This struct ties everything together: the provider, the view, and metadata.

struct QuickLaunchLockScreenWidget: Widget {
    /// A unique string that identifies this widget. WidgetKit uses it internally.
    let kind: String = "QuickLaunchLockScreenWidget"

    var body: some WidgetConfiguration {
        // StaticConfiguration means "no user configuration" —
        // the widget always shows the same data.
        // (For user-configurable widgets you'd use IntentConfiguration.)
        StaticConfiguration(kind: kind, provider: LockScreenProvider()) { entry in
            // iOS 17 introduced containerBackground for widget backgrounds.
            // We check availability so the widget also builds for iOS 16.
            if #available(iOSApplicationExtension 17.0, *) {
                LockScreenWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                LockScreenWidgetEntryView(entry: entry)
            }
        }
        .configurationDisplayName("Quick Launch")
        .description("Launch your favourite apps from the Lock Screen.")
        // Only offer Lock Screen sizes — not Home Screen sizes.
        .supportedFamilies([
            .accessoryCircular,
            .accessoryRectangular
        ])
    }
}

// MARK: - Xcode Canvas Previews
// These let you see the widget in the Xcode preview canvas (right-hand pane)
// without building to a device. Requires Xcode 15+.

#Preview("Circular", as: .accessoryCircular) {
    QuickLaunchLockScreenWidget()
} timeline: {
    LockScreenEntry(date: .now, shortcuts: Array(loadSharedShortcuts().prefix(3)))
}

#Preview("Rectangular", as: .accessoryRectangular) {
    QuickLaunchLockScreenWidget()
} timeline: {
    LockScreenEntry(date: .now, shortcuts: Array(loadSharedShortcuts().prefix(3)))
}
