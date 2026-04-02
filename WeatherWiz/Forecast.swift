//
//  Forecast.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-03-20.
//

import SwiftUI

struct Forecast: View {
    let forcastType: String
    var timeOrDay: String
    let weatherIMG: String
    let temperature: String
    
    var body: some View {
        HStack {
            Button(action: {
                // Previous action
            }) {
                Text("<")
                    .font(.largeTitle)
            }
            
            VStack {
                Text(forcastType)
                    .font(.largeTitle)
                VStack {
                    Text(timeOrDay)
                    Text(weatherIMG)
                        .font(.system(size: 50))
                    Text(temperature)
                }
                .padding(8)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Button(action: {
                // Next action
            }) {
                Text(">")
                    .font(.largeTitle)
            }
        }
        .padding()
    }
}

#Preview {
    Forecast(forcastType: "Daily", timeOrDay: "11AM", weatherIMG: "☁️", temperature: "10°C")
}
