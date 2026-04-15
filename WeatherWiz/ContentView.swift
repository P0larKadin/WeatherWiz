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
    
    @Query(filter: #Predicate<UserPreferences> { $0.username == "Bailey" }) //SELECT * FROM UserPreferences WHERE username = 'Bailey'
    private var returnedUsers: [UserPreferences] //holds the query results in an array
    
    @Query //SELECT * FROM City
    private var returnedCities: [City] //holds the query results in an array
    
    // If you intend to bind a current city, keep this binding injected by the parent.
    // For now, make it optional with a default for previews.
    
    var body: some View {
        VStack {
            if let row = returnedUsers.first {
                WeatherBoardView(cities: row.favCities, user: row)
            } else {
                EmptyView()
            }
        }
        //.padding()
        .onAppear {
            addInitialCities()
            createUserIfNeeded()
            print(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!)
        }
    }
    
    // Helper to resolve a list of (name, country) to City objects using current cache
    private func resolveCities(by keys: [(name: String, country: String)], from all: [City]) -> [City] {
        // Build a lookup keyed by "name|country" lowercased. If you later add state disambiguation, extend the key here.
        let lookup: [String: City] = Dictionary(uniqueKeysWithValues:
            all.map { city in
                let key = compositeKey(name: city.cityName, country: city.countryName)
                return (key, city)
            }
        )
        return keys.compactMap { lookup[compositeKey(name: $0.name, country: $0.country)] }
    }
    
    private func compositeKey(name: String, country: String) -> String {
        "\(name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())|\(country.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())"
    }
    
    private func createUserIfNeeded() {
        // Fetch existing users
        let allUsers = (try? context.fetch(FetchDescriptor<UserPreferences>())) ?? []

        let hasBailey = allUsers.contains { $0.username == "Bailey" }
        let hasKadin = allUsers.contains { $0.username == "Kadin" }

        // If both users already exist, nothing to do
        if hasBailey && hasKadin {
            return
        }

        // Ensure cities exist FIRST
        var allCities = (try? context.fetch(FetchDescriptor<City>())) ?? []

        if allCities.isEmpty {
            addInitialCities()
            allCities = (try? context.fetch(FetchDescriptor<City>())) ?? []
        }

        // Favorite city definitions (keys)
        let kadinFavKeys: [(String, String)] = [
            ("Vancouver", "Canada"),
            ("Tokyo", "Japan"),
            ("Kelowna", "Canada")
        ]

        let baileyFavKeys: [(String, String)] = [
            ("Kelowna", "Canada"),
            ("London", "England")
        ]

        // Resolve favorites into actual City objects
        let kadinFavs = resolveCities(by: kadinFavKeys, from: allCities)
        let baileyFavs = resolveCities(by: baileyFavKeys, from: allCities)

        // Create users
        if !hasKadin {
            let kadin = UserPreferences(
                username: "Kadin",
                favCities: kadinFavs,
                tempUnit: .celsius
            )
            context.insert(kadin)
        }

        if !hasBailey {
            let bailey = UserPreferences(
                username: "Bailey",
                favCities: baileyFavs,
                tempUnit: .celsius
            )
            context.insert(bailey)
        }

        // Commit once at the end
        try? context.save()
    }
    
    private func addInitialCities() {
        //Only add initial cities if havent already been added
        let existing = (try? context.fetch(FetchDescriptor<City>())) ?? []
        let existingKeys = Set(existing.map { $0.cityCountryKey })
        
        func insertIfMissing(_ city: City) {
            guard !existingKeys.contains(city.cityCountryKey) else { return }
            context.insert(city)
        }
        
        insertIfMissing(City(cityName: "Kelowna", stateName: "BC", countryName: "Canada", latitude: 49.8863, longitude: -119.4966))
        insertIfMissing(City(cityName: "Vancouver", stateName: "BC", countryName: "Canada", latitude: 49.2827, longitude: -123.1207))
        insertIfMissing(City(cityName: "London", countryName: "England", latitude: 51.5072, longitude: -0.1276))
        insertIfMissing(City(cityName: "Tokyo", countryName: "Japan", latitude: 35.6764, longitude: 139.6500))

        try? context.save() //COMMIT
    }
}

struct MainView: View {
    @Environment(\.modelContext) private var context //Initialize the container
    @State var wdModel = WeatherDataModel()

    // Accept a City instead of just name
    let city: City

    @State private var fetchedData: [Float]? = nil
    
    var body: some View {
        
        let temp: Float? = fetchedData?.indices.contains(0) == true ? fetchedData?[0] : nil
        let code: Int? = fetchedData?.indices.contains(1) == true ? Int(fetchedData?[1] ?? 0): nil
        
        ZStack{
            LinearGradient(colors: background(code: code), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            ScrollView{
                VStack {
                    Image("weatherWizLogo").resizable().frame(width: 300, height: 100)
                    WeatherConditionView(code: code, city: city).padding().animation(.easeInOut(duration: 1), value: code)
                    if let temp {
                        TemperatureView(temp: temp, bgColor: .black.opacity(0.1)).padding()
                    } else {
                        ProgressView().padding()
                    }
                    
                    HStack{
                        Forecast(mode: .daily, tempUnit: "celcius", city: city)
                        
                        Forecast(mode: .weekly, tempUnit: "celcius", city: city)
                    }.background(.black.opacity(0.1))
                    
                    
                    // Example embedding of WeatherDataModel if you want to show its UI:
                    // WeatherDataModel(city: city)
                }
                .task(id: city.id) {
                    fetchedData = await wdModel.getWeatherData(city: city)//helper.getWeatherData(cityName: city.cityName, city: city)
                }
            }
        }.navigationBarTitleDisplayMode(.inline)
         .toolbarBackground(.hidden, for: .navigationBar)
         .toolbarColorScheme(.dark, for: .navigationBar)
         .scrollContentBackground(.hidden)
    }
    
    func background(code: Int?) -> [Color]{
        switch WeatherConditionView.getWeatherCondition(code: code ?? 0) {
        case "Sunny":
            return [Color.blue, Color.yellow]
        case "Rainy":
            return [Color.gray, Color.blue]
        case "Cloudy":
            return [Color.blue, Color.white]
        case "Thunderstorm":
            return [Color.gray, Color.yellow]
        case "Snowy":
            return [Color.white, Color.gray]
        default:
            return [Color.blue, Color.yellow]
        }
    }
}

#Preview {
    ContentView()
}
