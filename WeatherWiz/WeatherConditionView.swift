//
//  WeatherConditionView.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-03-20.
//

import SwiftUI

struct WeatherConditionView: View {
    //@State var wdModel: WeatherDataModel
    let code: Int?
    var city: City
    

   // @State private var fetchedData: [Float]? = nil
    
    static func getWeatherEmoji(condition: String) -> String {
        switch condition {
        case "Sunny":
            return "☀️"
        case "Rainy":
            return "🌧️"
        case "Cloudy":
            return "☁️"
        case "Snowy":
            return "❄️"
        case "Thunderstorm":
            return "🌩️"
        case "Loading":
            return "⏳"
        default:
            return "🌤️"
        }
    }
    
    static func getWeatherCondition(code: Float) -> String {
        switch code {
        case 0: // Sunny
            return "Sunny"
        case 51...67, 80...82: // Rainy
            return "Rainy"
        case 1...48: // Cloudy
            return "Cloudy"
        case 71...77, 85, 86: // Snowy
            return "Snowy"
        case 95...99: // Thunderstorm
            return "Thunderstorm"
        default: // Other
            return "Sunny"
        }
    }

    var body: some View {
        let condition: String = {
            guard let code else { return "Loading" }
            return WeatherConditionView.getWeatherCondition(code: code)
        }()

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
            case "Thunderstorm":
                return WeatherData.thunderMsgs.randomElement() ?? "Watch out for a storm!"
            case "Loading":
                return "Fetching latest weather…"
            default:
                return "Wonderful weather we're having"
            }
        }()

        let emoji: String = WeatherConditionView.getWeatherEmoji(condition: condition)

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
        .task {
            //fetchedData = await wdModel.getWeatherData(cityName: self.city)
        }
    }
}

#Preview {
    // Provide a stub instance if needed when previewing
    // WeatherConditionView(wdModel: WeatherDataModel(), city: "Kelowna")
}
