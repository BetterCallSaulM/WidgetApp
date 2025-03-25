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
        let affirmation = await fetchAffirmation() ?? "Stay positive!"
        return AffirmationEntry(date: Date(), affirmation: affirmation)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<AffirmationEntry> {
        let affirmation = getSavedAffirmation() ?? "Keep going!"
        let entry = AffirmationEntry(date: Date(), affirmation: affirmation)

        // Refresh every hour
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!

        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
    
    private func fetchAffirmation() async -> String? {
        let url = URL(string: "https://www.affirmations.dev/")!

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(Affirmation.self, from: data)
            return decodedResponse.affirmation
        } catch {
            print("Error fetching affirmation: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func getSavedAffirmation() -> String? {
        let sharedDefaults = UserDefaults(suiteName: "group.SaulMachuca.WidgetApp.Affirmatio")
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
        VStack {
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
