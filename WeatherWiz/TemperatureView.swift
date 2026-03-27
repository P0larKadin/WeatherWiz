//
//  TemperatureView.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-03-20.
//

import SwiftUI

struct TemperatureView: View {
    @State private var isEnabled: Bool = true
    var body: some View {
        let celsius: Double = WeatherData.temperatures
        VStack{
            Text("Current Temperature").font(.custom("Arial", size: 30)).bold().padding()
            
            HStack{
                Text(isEnabled ? convertToFahrenheit(cel: celsius).description + " \u{00B0}F" : celsius.description + " \u{00B0}C").font(.custom("Arial", size: 50)).bold().padding(50)
                
                //Form{
                VStack{
                    Text(" \u{00B0}C      \u{00B0}F")
                    Toggle("", isOn: $isEnabled).frame(width: 1)
                }.padding()
                //}
            }
        }
    }
    
    func convertToFahrenheit(cel: Double) -> Double {
        return (cel * 9/5) + 32
    }
    
    func convertToCelsius(fahrenheit: Double) -> Double {
        return (fahrenheit - 32) * 5/9
    }
}

#Preview {
    TemperatureView()
}
