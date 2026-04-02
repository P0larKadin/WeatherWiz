//
//  WeatherData.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-03-20.
//

import Foundation
//import OpenMeteoSdk

struct WeatherData{
    static let temperatures: Double = 30.0
    static let conditions: [String] = ["Sunny", "Rainy", "Cloudy", "Snowy"]
    static let cities: [String] = ["Kelowna", "Vancouver", "Toronto", "Calgary"]
    
    //Custom messages based on weather condition
    static let sunnyMsgs: [String] = ["Enjoy the sunshine!", "Soak in some raysss", "Dress light!", "T-Shirt weather!"]
    static let rainyMsgs: [String] = ["Pack an umbrella!", "It's going to rain!", "temp", "temp"]
    static let cloudyMsgs: [String] = ["temp", "Grey and gloomy :(", "Stay cozy!", "temp"]
    static let snowyMsgs: [String] = ["Bundle up!", "temp", "temp", "Snow day!"]
}
