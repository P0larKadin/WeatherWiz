//
//  ContentView.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-02-27.
//

import SwiftUI
struct ContentView: View {
    var body: some View {
        VStack {
            WeatherConditionView().padding()
            TemperatureView().padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

//Test
