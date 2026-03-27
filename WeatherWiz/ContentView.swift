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
    private var returnedRows: [UserPreferences] //holds the query results in an array
    var body: some View {
        VStack {
            if let row = returnedRows.first{
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
        }
    }
    
    private func createUserIfNeeded(){
        guard returnedRows.isEmpty else{
            return
        }
        
        let userPrefs = UserPreferences(username: "ExampleUsername", favCities: [], tempUnit: .celsius )
        context.insert(userPrefs)
        try? context.save()
    }
}

#Preview {
    ContentView()
}



//Test
