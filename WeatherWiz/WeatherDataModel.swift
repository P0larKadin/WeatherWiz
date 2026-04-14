//
//  WeatherDataModel.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-04-02.
//

import SwiftUI
import OpenMeteoSdk
import SwiftData

struct WeatherDataModel: View {
    @State private var temperature: Float?
    @State private var weatherCode: Float?

    var body: some View {
        Text(temperature != nil ? "\(temperature!)°C" : "Loading...")
            .task {
                await temperature = getWeatherData(cityName: "London").first
            }
        Text(weatherCode != nil ? "\(weatherCode!)" : "Loading...")
            .task {
                await weatherCode = getWeatherData(cityName: "London").last
            }
    }
    
    func getWeatherDataFull(cityName: String = "", difference: Int = 0) async -> [[Float32]] {
        var hour = Calendar.current.component(.hour, from: Date())
        hour = hour + difference
        
        let lat: Double
        let long: Double
        let timezone: String = "America%2FLos_Angeles"
        
        switch cityName {
        case "Kelowna":
            lat = 49.8831
            long = -119.4857
        case "Vancouver":
            lat = 49.2827
            long = -123.1207
        case "London":
            lat = 51.5074
            long = -0.1278
            hour = hour + 8
        default:
            lat = 49.8831
            long = -119.4857
        }
        
        let url = URL(string:
            "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(long)&daily=temperature_2m_mean,weather_code&hourly=temperature_2m,weather_code&timezone=\(timezone)&format=flatbuffers"
        )!
        
        // Prepare 2D array for full series: [ [temps...], [weatherCodes...] ]
        var data: [[Float32]] = [[], [], [], []]
        
        do {
            let responses = try await WeatherApiResponse.fetch(url: url)
            let response = responses[0]

            let hourly = response.hourly!
            let daily = response.daily!

            let hourlyTemps: [Float32] = hourly.variables(at: 0)!.values
            let hourlyCodes: [Float32] = hourly.variables(at: 1)!.values
            let dailyTemps: [Float32] = daily.variables(at: 0)!.values
            let dailyCodes: [Float32] = daily.variables(at: 1)!.values

            data[0] = hourlyTemps
            data[1] = hourlyCodes
            data[2] = dailyTemps
            data[3] = dailyCodes
        } catch {
            print("Error: \(error)")
        }
        return data
    }

    func getWeatherData(cityName: String = "", difference: Int = 0) async -> [Float]{
        var data : [Float] = [0,0]
        var hour = Calendar.current.component(.hour, from: Date())
        hour = hour + difference
        
        let lat: Double
        let long: Double
        let timezone: String = "America%2FLos_Angeles"
        
        switch cityName {
        case "Kelowna":
            lat = 49.8831
            long = -119.4857
            break
        case "Vancouver":
            lat = 49.2827
            long = -123.1207
        case "London":
            lat = 51.5074
            long = -0.1278
            hour = hour + 8
            break
        default:
            lat = 49.8831
            long = -119.4857
            break
        }
        
            
        
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

#Preview{
    WeatherDataModel()
}
