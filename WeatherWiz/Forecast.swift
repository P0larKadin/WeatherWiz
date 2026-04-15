//
//  Forecast.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-03-20.
//

import SwiftUI


enum ForcastMode{
    case daily
    case weekly
    
    var forcastType: String {
        switch self {
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        }
    }
    
    func timeOrDay(for hour: Int) -> String {
        switch self {
        case .daily: 
            var components = DateComponents()
                    components.hour = hour
                    let calendar = Calendar.current
                    let date = calendar.date(from: components) ?? Date()
                    return date.formatted(.dateTime.hour(.defaultDigits(amPM: .abbreviated)))
        case .weekly:
            guard let date = Calendar.current.date(byAdding: .day, value: hour, to: Date()) else {
                            return "-"
                        }
                        return date.formatted(.dateTime.weekday(.abbreviated))
        }
    }
    
}

struct Forecast: View {
    let mode: ForcastMode
    let tempUnit: String
    let city: City
    
    //For the arrow button animations
    let animationDuration: CGFloat = 0.5
    
    @State private var hourlyTemperatures: [Float]?
    @State private var hourlyWeatherCodes: [Float]?
    @State private var dailyTemperatures: [Float]?
    @State private var dailyWeatherCodes: [Float]?
    @State private var isLoading: Bool = true
    //@State private var hour: Int = Calendar.current.component(.hour, from: Date())
    @State private var hour: Int = 0
    private var model = WeatherDataModel()
    
    // Explicit initializer to avoid private memberwise init
    init(mode: ForcastMode, tempUnit: String, city: City) {
        self.mode = mode
        self.tempUnit = tempUnit
        self.city = city
        // @State vars start at their declared defaults; no direct init needed
        // model has a default initializer
    }
    
    private var weatherEmoji: String {
        switch mode {
        case .daily:
            guard let codes = hourlyWeatherCodes, hour >= 0, hour < codes.count else { return "⏳" }
            let condition = WeatherConditionView.getWeatherCondition(code: Int(codes[hour]))
            return WeatherConditionView.getWeatherEmoji(condition: condition)
        case .weekly:
            guard let codes = dailyWeatherCodes, hour >= 0, hour < codes.count else { return "⏳" }
            let condition = WeatherConditionView.getWeatherCondition(code: Int(codes[hour]))
            return WeatherConditionView.getWeatherEmoji(condition: condition)
        }
    }
    
    private var weatherTemp: String {
        switch mode {
        case .daily:
            guard let temps = hourlyTemperatures, hour >= 0, hour < temps.count else { return "--" }
            switch tempUnit{
            case "celcius":
                return Int(temps[hour]).description + "°C"
            case "fahrenheit":
                return (Int(temps[hour] * 9/5) + 32).description + "°F"
            default:
                return Int(temps[hour]).description + "°C"
            }
        case .weekly:
            guard let temps = dailyTemperatures, hour >= 0, hour < temps.count else { return "--" }
            switch tempUnit{
            case "celcius":
                return Int(temps[hour]).description + "°C"
            case "fahrenheit":
                return (Int(temps[hour] * 9/5) + 32).description + "°F"
            default:
                return Int(temps[hour]).description + "°C"
            }
        }
    }
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation(.easeInOut(duration: animationDuration)){
                    // Previous action (e.g., move one hour/day back)
                    hour = max(0, hour - 1)
                }
            }) {
                Text("<")
                    .font(.largeTitle)
            }
            
            VStack {
                Text(mode.forcastType)
                    .font(.largeTitle)
                VStack {
                    Text(mode.timeOrDay(for: hour))
                    Text(weatherEmoji)
                        .font(.system(size: 50))
                    Text(weatherTemp)
                }
                .padding(8)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: animationDuration)){
                    // Next action (e.g., move one hour/day forward)
                    switch mode {
                    case .daily:
                        if let temps = hourlyTemperatures {
                            hour = min(temps.count - 1, hour + 1)
                        } else {
                            hour += 1
                        }
                    case .weekly:
                        if let temps = dailyTemperatures {
                            hour = min(temps.count - 1, hour + 1)
                        } else {
                            hour += 1
                        }
                    }
                }
            }) {
                Text(">")
                    .font(.largeTitle)
            }
        }
        .padding()
        .task {
            setInitialHour()
            await loadData()
        }
    }
    
    private func setInitialHour() {
        switch mode {
        case .daily:
            hour = Calendar.current.component(.hour, from: Date())
        case .weekly:
            hour = 0;
        }
    }
    
    private func loadData() async {
        isLoading = true
        let data = await model.getWeatherDataFull(city: city)
        // Defensive indexing
        if data.indices.contains(0) { hourlyTemperatures = data[0] }
        if data.indices.contains(1) { hourlyWeatherCodes = data[1] }
        
        if data.indices.contains(2) { dailyTemperatures = data[2] }
        if data.indices.contains(3) { dailyWeatherCodes = data[3] }
        isLoading = false
    }
}

#Preview {
    //Forecast(mode: .daily, tempUnit: "celcius", city: "London")
    //Forecast(mode: .weekly, tempUnit: "fahrenheit", city: "Kelowna")
}
