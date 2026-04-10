//
//  WeatherConditionView.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-03-20.
//

import SwiftUI

struct WeatherConditionView: View {
    var city: City
    var body: some View {
        // Compute condition and message up front
        let condition: String = WeatherData.conditions.randomElement() ?? "Sunny"
        let weatherMsg: String = {
            switch condition {
            case "Sunny":
                return WeatherData.sunnyMsgs.randomElement() ?? "Enjoy the sunshine!"
            case "Rainy":
                return WeatherData.rainyMsgs.randomElement() ?? "Pack an umbrella!"
            case "Cloudy":
                return WeatherData.cloudyMsgs.randomElement() ?? "Stay cozy!"
            case "Snowy":
                return WeatherData.snowyMsgs.randomElement() ?? "Bundle up!"
            default:
                return "Wonderful weather we're having"
            }
        }()

        // change emoji based on condition
        let emoji: String = {
            switch condition {
            case "Sunny":
                return "☀️"
            case "Rainy":
                return "🌧️"
            case "Cloudy":
                return "☁️"
            case "Snowy":
                return "❄️"
            default:
                return "🌤️"
            }
        }()

        VStack {
            Text("Today's Weather is:")
                .padding()
            Text(emoji)
                .font(.system(size: 100))
                .minimumScaleFactor(0.5)
            Text(condition)
                .font(.largeTitle)
                .padding()
            Text(weatherMsg)
        }
    }
}

#Preview {
    //WeatherConditionView()
}
