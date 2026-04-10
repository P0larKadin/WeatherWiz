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
    
    
    @Query(filter: #Predicate<UserPreferences> {$0.username == "Kadin"}) //SELECT * FROM UserPreferences WHERE username = 'ExampleUsername'
    private var returnedUsers: [UserPreferences] //holds the query results in an array
    
    @Query //SELECT * FROM City
    private var returnedCities: [City] //holds the query results in an array
    
    //@State public var curCity: City?
    
    var body: some View {
        VStack {
            if let row = returnedUsers.first{
                Text("Hello \(row.username).")
                WeatherBoard(row.favCities)
            }else{
                Text("Set up user")
            }
            
            if let defaultCity = returnedCities.first{
                
                WeatherConditionView(city: defaultCity).padding()
                TemperatureView().padding()
            }
        }
        .padding()
        .onAppear(){
            createUserIfNeeded()
            addInitialCities()
            // Print this in your AppDelegate or initial View
            print(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!)

        }
    }
    
    private func listFavoriteCities(_ cities: [String]){
        
    }
    
    private func createUserIfNeeded(){
       guard returnedUsers.isEmpty else{
           
            return
        }
           
        let userPrefs = UserPreferences(username: "ExampleUsername", favCities: [], tempUnit: .celsius )
        let kadin = UserPreferences(username: "Kadin", favCities: ["Vanouver", "Tokyo", "Kelowna"], tempUnit: .celsius )
        let bailey = UserPreferences(username: "Bailey", favCities: ["Kelowna", "London"], tempUnit: .celsius )
        context.insert(userPrefs) //INSERT
        context.insert(kadin)
        context.insert(bailey)
        try? context.save() //COMMIT
    }
    
    private func addInitialCities(){
        guard returnedCities.isEmpty else{
            return
        }
        
        let kelowna = City(cityName: "Kelowna", stateName: "BC", countryName: "Canada", latitude: 49.8863, longitude: -119.4966)
        context.insert(kelowna)
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
