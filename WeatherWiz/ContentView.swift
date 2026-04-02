//
//  ContentView.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-02-27.
//

import SwiftUI
import SwiftData
//import Foundation
struct ContentView: View {
    @Environment(\.modelContext) private var context //Initialize the container
    
    @Query(filter: #Predicate<UserPreferences> {$0.username == "ExampleUsername"}) //SELECT * FROM UserPreferences WHERE username = 'ExampleUsername'
    private var returnedUsers: [UserPreferences] //holds the query results in an array
    
    @Query //SELECT * FROM City
    private var returnedCities: [City] //holds the query results in an array
    
    var body: some View {
        VStack {
            if let row = returnedUsers.first{
                Text("Hello \(row.username).")
            }else{
                Text("Set up user")
            }
            
            WeatherConditionView().padding()
            TemperatureView().padding()
        }
        .padding()
        .onAppear(){
            createUserIfNeeded()
            addInitialCities()
            // Print this in your AppDelegate or initial View
            print(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!)

        }
    }
    
    private func createUserIfNeeded(){
        guard returnedUsers.isEmpty else{
            return
        }
           
        let userPrefs = UserPreferences(username: "ExampleUsername", favCities: [], tempUnit: .celsius )
        context.insert(userPrefs) //INSERT
        try? context.save() //COMMIT
    }
    
    private func addInitialCities(){
        guard returnedCities.isEmpty else{
            return
        }
        
        context.insert(City(cityName: "Kelowna", stateName: "BC", countryName: "Canada", latitude: 49.8863, longitude: -119.4966))
        context.insert(City(cityName: "Vancouver", stateName: "BC", countryName: "Canada", latitude: 49.2827, longitude: -123.1207))
        context.insert(City(cityName: "London", countryName: "London", latitude: 51.5072, longitude: -0.1276, timeDifference: 8))
        context.insert(City(cityName: "Tokyo", countryName: "Japan", latitude: 35.6764, longitude: 139.6500, timeDifference: 8))
        //context.insert(City(cityName: "London", countryName: "London", latitude: 51.5072, longitude: -0.1276, timeDifference: 8))
        
        try? context.save() //COMMIT
    }
}

#Preview {
    ContentView()
}



//Test
