//
//  WeatherDataModel.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-04-02.
//


import SwiftUI
import OpenMeteoSdk
import SwiftData

@Observable
final class WeatherDataModel{
    func getWeatherData(city: City, difference: Int = 0) async -> [Float]{
        var data : [Float] = [0,0]
        var hour = Calendar.current.component(.hour, from: Date())
        hour = hour + difference
        
        let lat: Double = city.latitude
        let long: Double = city.longitude
        let timezone: String = "auto"
        
        
        //TODO: Change to use the database's values
//        switch cityName {
//        case "Kelowna":
//            lat = 49.8831
//            long = -119.4857
//            break
//        case "Vancouver":
//            lat = 49.2827
//            long = -123.1207
//        case "London":
//            lat = 51.5074
//            long = -0.1278
//            hour = hour + 8
//            break
//        default:
//            lat = 49.8831
//            long = -119.4857
//            break
//        }
        
            
        
        let url = URL(string:
            "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(long)&hourly=temperature_2m,weather_code&timezone=\(timezone)&format=flatbuffers"
        )!
        do {
            let responses = try await WeatherApiResponse.fetch(url: url)
            let response = responses[0] //Locations

            let hourly = response.hourly!
            let temps = hourly.variables(at: 0)!.values //Info (Temperature = 0, ...)
            let weatherCode = hourly.variables(at: 1)!.values

            data[0] = temps[hour] //Time
            data[1] = weatherCode[hour] //Weather Code
            
            
            
        } catch {
            print("Error: \(error)")
        }
        return data
    }
}
