//
//  UserPreferences.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-03-25.
//

import Foundation
import SwiftData

@Model
class UserPreferences {
    @Attribute(.unique) var username: String
    var password: String?
    var favCities: [City]
    var tempUnit: TemperatureUnit

    init(username: String = "ExampleUsername",
         password: String? = nil,
         favCities: [City] = [],
         tempUnit: TemperatureUnit = .celsius) {
        self.username = username
        self.favCities = favCities
        self.tempUnit = tempUnit
        self.password = password
    }

    // Convenience initializer without password
    init(username: String = "ExampleUsername",
         favCities: [City] = [],
         tempUnit: TemperatureUnit = .celsius) {
        self.username = username
        self.favCities = favCities
        self.tempUnit = tempUnit
    }

    // Allow users to add a city to their favorites (prevents duplicates by identity)
    func addFavoriteCity(_ city: City) {
        guard favCities.contains(where: { $0.cityCountryKey == city.cityCountryKey }) == false else { return }
        favCities.append(city)
    }

    // Allow users to remove a city from their favorites (by identity)
    func removeFavoriteCity(_ city: City) {
        favCities.removeAll { $0.cityCountryKey == city.cityCountryKey }
    }

    // Set temp unit by passing in a TemperatureUnit
    func setTemperatureUnit(_ unit: TemperatureUnit) {
        self.tempUnit = unit
    }

    // Set temp unit by passing in a string
    func setTemperatureUnit(_ str: String) {
        let unit = str.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if unit == "CELSIUS" || unit == "C" {
            self.tempUnit = .celsius
        } else if unit == "FAHRENHEIT" || unit == "F" {
            self.tempUnit = .fahrenheit
        } else {
            // Invalid unit entered as a string
            debugPrint("Attempted to set to an invalid temperature unit: ", str)
        }
    }
}

enum TemperatureUnit: String, Codable {
    case celsius = "celsius"
    case fahrenheit = "fahrenheit"
}
