//
//  Cities.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-04-02.
//

import Foundation
import SwiftData

@Model
class City {
    var cityName: String
    var stateName: String?
    var countryName: String
    var latitude: Double
    var longitude: Double
    var timeDifference: Int
    
    init(cityName: String, stateName: String, countryName: String, latitude: Double, longitude: Double, timeDifference: Int = 0){
        self.cityName = cityName
        self.stateName = stateName
        self.countryName = countryName
        self.latitude = latitude
        self.longitude = longitude
        self.timeDifference = timeDifference
    }
    
    init(cityName: String, countryName: String, latitude: Double, longitude: Double, timeDifference: Int = 0){
        self.cityName = cityName
        self.countryName = countryName
        self.latitude = latitude
        self.longitude = longitude
        self.timeDifference = timeDifference
    }
}
