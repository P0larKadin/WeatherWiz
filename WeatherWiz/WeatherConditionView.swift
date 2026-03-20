//
//  WeatherConditionView.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-03-20.
//

import SwiftUI

struct WeatherConditionView: View {
    var body: some View {
        let condition: String = WeatherData.conditions[Int.random(in: 0..<WeatherData.conditions.count)]
        var msg: String = ""
        switch condition {
        case "Sunny":
            var msg: String = WeatherData.sunnyMsgs[Int.random(in: 0..<WeatherData.cloudyMsgs.count)]
        case "Rainy":
            var msg: String = WeatherData.rainyMsgs[Int.random(in: 0..<WeatherData.cloudyMsgs.count)]
        case "Cloudy":
            var msg: String = WeatherData.cloudyMsgs[Int.random(in: 0..<WeatherData.cloudyMsgs.count)]
        case "Snowy":
            var msg: String = WeatherData.snowyMsgs[Int.random(in: 0..<WeatherData.cloudyMsgs.count)]
        default:
            var msg: String = "Wonderful weather we're having"
        }
        
        VStack {
            Text(condition == "Cloudy" ? "🌤️" : "☀️").font(Font.largeTitle)
            Text("Todays Weather is:")
            Text("\(condition)")
            Text("\(msg)").font(Font.largeTitle)
        }
        
        
    }
}

#Preview {
    WeatherConditionView()
}
