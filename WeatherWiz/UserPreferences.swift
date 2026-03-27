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
    var favCities: [String]
    var tempUnit: TemperatureUnit
    
    init(username: String = "ExampleUsername", favCities: [String] = [], tempUnit: TemperatureUnit = .celsius){
        self.username = username
        self.favCities = favCities
        self.tempUnit = tempUnit
    }
    
    //Allow users to add a city to their favs
    func addFavoriteCity(_ city: String){
        favCities.append(city)
    }
    
    //Allow users to remove a city from their favs
    func removeFavoriteCity(_ city: String){
        favCities.removeAll(where: { $0 == city })
    }
    
    //Set temp unit by passing in a TemperatureUnit (Can alternatively just modify the tempUnit var directly)
    func setTemperatureUnit(_ unit: TemperatureUnit){
        self.tempUnit = unit
    }
    
    //Set temp unit by passing in a string
    func setTemperatureUnit(_ str: String){
        let unit = str.uppercased()
        if unit == "CELSIOUS" || unit == "C"{
            self.tempUnit = .celsius
        }else if unit == "FARENHEIT" || unit == "F" {
            self.tempUnit = .fahrenheit
        }else{
            //Invalid unit entered as a string
            debugPrint("Attempted to set to an invalid temperature unit: ", str)
        }
    }
}

enum TemperatureUnit: String, Codable {
    case celsius = "celsius"
    case fahrenheit = "fahrenheit"
}
