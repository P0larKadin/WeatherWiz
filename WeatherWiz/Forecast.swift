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
        HStack{
            Button("<"){
                
            }.font(.largeTitle)
            VStack{
                Text(type)
                    .font(.largeTitle)
                VStack{
                    Text(timeOrDay)
                    Text(weatherIMG).font(.system(size: 50))
                    Text(temperature)
                }.background(Color.blue)
            }
            Button(">"){
                
            }.font(.largeTitle)
            
        }
        
        
    }
}

#Preview {
    Forecast(forcastType: "Daily",timeOrDay: "11AM",weatherIMG: "☁️",temperature: "10°C")
}
