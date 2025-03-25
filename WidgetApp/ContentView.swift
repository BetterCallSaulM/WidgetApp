//
//  ContentView.swift
//  WidgetApp
//
//  Created by Saul Machuca on 3/25/25.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    
    @State var affirmation: String = ""
    
    var body: some View {
        VStack {
            Image("b")
                .imageScale(.large)
                .foregroundStyle(.blue)
            Text(affirmation)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
        .task {
            await getAffirmation()
        }
    }
    
    func refreshWidget() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func getAffirmation() async {
        let url = URL(string: "https://www.affirmations.dev/?ref=freepublicapis.com")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(Affirmation.self, from: data)
            
            let sharedDefaults = UserDefaults(suiteName: "group.com.SaulMachuca.affirmations")
            sharedDefaults?.set(decodedResponse.affirmation, forKey: "currentAffirmation")
            
            affirmation = decodedResponse.affirmation
            refreshWidget()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView(affirmation: "You not chopped gang ❤️")
}

struct Affirmation: Codable {
    let affirmation: String
}
