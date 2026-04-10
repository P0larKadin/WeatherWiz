//
//  WeatherConditionView.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-03-20.
//

import SwiftUI

struct WeatherConditionView: View {
    //@State var wdModel: WeatherDataModel
    let code: Float?
    var city: String
    

   // @State private var fetchedData: [Float]? = nil

    var body: some View {
        // Safely unwrap data and compute condition/message/emoji
        //let code: Float? = fetchedData?.indices.contains(1) == true ? fetchedData?[1] : nil

        let condition: String = {
            guard let code else { return "Loading" }
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
            case "Thunderstorm":
                return "🌩️"
            case "Loading":
                return "⏳"
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
        .task {
            // Call the async function in an async context
            //fetchedData = await wdModel.getWeatherData(cityName: self.city)
        }
    }
}

#Preview {
    //Provide a stub instance if needed when previewing
    // WeatherConditionView(wdModel: WeatherDataModel(), city: "Kelowna")
}
