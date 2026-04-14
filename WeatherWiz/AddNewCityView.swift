//
//  AddNewCityView.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-04-14.
//

import SwiftUI
import SwiftData

struct AddNewCityView: View {

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    let user: UserPreferences

    @State private var cityName = ""
    @State private var country = ""
    @State private var latitude = ""
    @State private var longitude = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("City Info")) {
                    TextField("City name", text: $cityName)
                    TextField("Country", text: $country)
                }

                Section(header: Text("Coordinates")) {
                    TextField("Latitude", text: $latitude)
                        .keyboardType(.decimalPad)

                    TextField("Longitude", text: $longitude)
                        .keyboardType(.decimalPad)
                }

                Button("Save City") {
                    saveCity()
                }
                .disabled(!isValid)
            }
            .navigationTitle("Add City")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var isValid: Bool {
        guard
            !cityName.isEmpty,
            !country.isEmpty,
            Double(latitude) != nil,
            Double(longitude) != nil
        else {
            return false
        }
        return true
    }

    private func saveCity() {
        let lat = Double(latitude) ?? 0
        let lon = Double(longitude) ?? 0

        // Prevent duplicates using your existing key system
        let key = "\(cityName.lowercased())_\(country.lowercased())"
        
        

        let existing = (try? context.fetch(FetchDescriptor<City>())) ?? []
        guard !existing.contains(where: { $0.cityCountryKey == key }) else {
            dismiss()
            return
        }

        let city = City(
            cityName: cityName,
            stateName: "",
            countryName: country,
            latitude: lat,
            longitude: lon
        )

        context.insert(city)
        
        //Adds the new city to the user's favs automatically
        if !user.favCities.contains(where: {$0.cityCountryKey == city.cityCountryKey}) {
            user.favCities.append(city)
        }
        
        try? context.save()

        dismiss()
    }
}

#Preview(){
    AddNewCityView(user: UserPreferences())
}
