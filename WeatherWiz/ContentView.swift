//
//  ContentView.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-02-27.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context

    @Query
    private var returnedCities: [City]

    // Tracks who is logged in. nil = show login screen.
    @State private var loggedInUser: UserPreferences? = nil

    var body: some View {
        VStack {
            if let user = loggedInUser {
                // ✅ Logged in — show their weather board
                WeatherBoardView(cities: user.favCities)
            } else {
                // 🔒 Not logged in — show login screen
                LoginView(loggedInUser: $loggedInUser)
            }
        }
        .padding()
        .onAppear() {
            createUsersIfNeeded()
            addInitialCities()
            print(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!)
        }
    }

    private func createUsersIfNeeded() {
        // Manually fetch since we removed the @Query predicate
        let descriptor = FetchDescriptor<UserPreferences>()
        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }

        context.insert(UserPreferences(username: "ExampleUsername", favCities: [],                               tempUnit: .celsius))
        context.insert(UserPreferences(username: "Kadin",           favCities: ["Vancouver", "Tokyo", "Kelowna"], tempUnit: .celsius))
        context.insert(UserPreferences(username: "Bailey",          favCities: ["Kelowna", "London"],             tempUnit: .celsius))
        try? context.save()
    }

    private func addInitialCities() {
        guard returnedCities.isEmpty else { return }

        context.insert(City(cityName: "Kelowna",  stateName: "BC", countryName: "Canada", latitude: 49.8863, longitude: -119.4966))
        context.insert(City(cityName: "Vancouver", stateName: "BC", countryName: "Canada", latitude: 49.2827, longitude: -123.1207))
        context.insert(City(cityName: "London",                     countryName: "London", latitude: 51.5072, longitude: -0.1276,   timeDifference: 8))
        context.insert(City(cityName: "Tokyo",                      countryName: "Japan",  latitude: 35.6764, longitude: 139.6500,  timeDifference: 8))
        try? context.save()
    }
}

struct MainView: View {
    @Environment(\.modelContext) private var context
    @State var wdModel = WeatherDataModel()
    var cityName1: String

    @State private var fetchedData: [Float]? = nil

    var body: some View {
        let temp: Float? = fetchedData?.indices.contains(0) == true ? fetchedData?[0] : nil
        let code: Float? = fetchedData?.indices.contains(1) == true ? fetchedData?[1] : nil
        VStack {
            WeatherConditionView(code: code, city: cityName1).padding()
            if let temp {
                TemperatureView(temp: temp).padding()
            } else {
                ProgressView().padding()
            }
        }
        .task {
            fetchedData = await wdModel.getWeatherData(cityName: cityName1)
        }
    }
}

#Preview {
    ContentView()
}
