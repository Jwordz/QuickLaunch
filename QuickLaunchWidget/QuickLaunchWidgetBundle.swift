// QuickLaunchWidget/QuickLaunchWidgetBundle.swift
//
// Purpose: The entry point for the widget extension.
//
// 📖 What is a WidgetBundle?
// Just like QuickLaunchApp.swift is the entry point for your main app,
// this file is the entry point for your widget extension.
// It tells iOS which widgets this extension provides.
// If you add more widgets later, you register them here.

import WidgetKit
import SwiftUI

/// @main marks this as the widget extension's entry point.
/// The bundle lists every widget this extension offers.
@main
struct QuickLaunchWidgetBundle: WidgetBundle {
    var body: some Widget {
        // Register our Lock Screen widget.
        // Add more widgets here (comma-separated) if you create them later.
        QuickLaunchLockScreenWidget()
    }
}
