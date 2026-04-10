//
//  TemperatureView.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-03-20.
//

import SwiftUI

struct TemperatureView: View {
    @State private var isEnabled: Bool = true
    var bgColor: Color = Color.blue.opacity(0.1)
    
    let degreeSymbol: String = "\u{00B0}"
    let temp: Float
    
    init(temp: Float){
        self.temp = temp
    }
    
    init(temp: Float, bgColor: Color = Color.blue.opacity(0.1)){
        self.bgColor = bgColor
        self.temp = temp
    }
    
    var body: some View {
        let celsius: Int = (Int)(temp)//.formatted(.number.precision(.fractionLength(0)))
        VStack{
            Text("Current Temperature").font(.custom("Arial", size: 35)).bold().padding()
            
            HStack{
                Text(isEnabled ? convertToFahrenheit(cel: celsius).description + " \(degreeSymbol)F" : celsius.description + " \(degreeSymbol)C").font(.custom("Arial", size: 50)).bold().frame(width: 175).padding(15)
                
                tempTypeToggleButton()
            }
        }.background(bgColor)
    }
    
    func convertToFahrenheit(cel: Int) -> Int {
        return (cel * 9/5) + 32
    }
    
    func convertToCelsius(fahrenheit: Int) -> Int {
        return (fahrenheit - 32) * 5/9
    }
    
    func tempTypeToggleButton(fontSize: CGFloat = 30, buttonSize: CGFloat = 1.3) -> some View {
        VStack{
            HStack{
                Text("\(degreeSymbol)C").font(.custom("Arial", size: fontSize))
                Text("  ")//Buffer
                Text("\(degreeSymbol)F").font(.custom("Arial", size: fontSize))
            }
            Toggle("", isOn: $isEnabled).frame(width: 1)
                .scaleEffect(buttonSize)
        }.padding()
    }
}

#Preview {
    //TemperatureView(/*bgColor: Color.blue*/)
    //TemperatureView().tempTypeToggleButton()
}
