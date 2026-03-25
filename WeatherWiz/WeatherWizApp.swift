//
//  WeatherWizApp.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-02-27.
//

import SwiftUI
import SwiftData //Needed to allow this to be using SQLite/SwiftData

@main
struct WeatherWizApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: UserPreferences.self)
                //Syntax for multiple classes as tables in the SQLite DB: .modelContainer(for: [ClassName1.self, ClassName2.self, ..., ClassNameN.self])
        }
    }
}
