//
//  AffirmationWidget.swift
//  AffirmationWidget
//
//  Created by Saul Machuca on 3/25/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> AffirmationEntry {
        AffirmationEntry(date: Date(), affirmation: "Fetching affirmation...")
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> AffirmationEntry {
        let affirmation = getSavedAffirmation() ?? "Kys"
        return AffirmationEntry(date: Date(), affirmation: affirmation)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<AffirmationEntry> {
        let affirmation = getSavedAffirmation() ?? "Kys"
        let entry = AffirmationEntry(date: Date(), affirmation: affirmation)

        // Refresh every 3 hours (to ensure it keeps updating)
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 3, to: Date())!

        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }

    private func getSavedAffirmation() -> String? {
        let sharedDefaults = UserDefaults(suiteName: "group.com.SaulMachuca.affirmations")
        return sharedDefaults?.string(forKey: "currentAffirmation")
    }
}

struct AffirmationEntry: TimelineEntry {
    let date: Date
    let affirmation: String
}

struct AffirmationWidgetEntryView: View {
    var entry: AffirmationEntry

    var body: some View {
        HStack {
            Image("b")
            Text(entry.affirmation)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct AffirmationWidget: Widget {
    let kind: String = "AffirmationWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            AffirmationWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Affirmation")
        .description("Fetches and displays an affirmation from the internet.")
    }
}

struct Affirmation: Codable {
    let affirmation: String
}

#Preview(as: .systemLarge) {
    AffirmationWidget()
} timeline: {
    AffirmationEntry(date: .now, affirmation: "You not chopped gang ❤️")
}
