//
//  WeatherBoardView.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-03-20.
//

import SwiftUI

struct WeatherBoardView: View {
    var cities: [City]
    @Binding var loggedInUser: UserPreferences?
    @State var search: String = ""
    @State private var showAddCityWindow = false
    @State private var showLoginSheet = false
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())] //Used for the LazyVGrid
    
    //@ViewBuilder
    var body: some View {
        NavigationStack{
            VStack{
                Title()
                Divider().padding()
                ScrollView{
                    LazyVGrid(columns: columns, spacing: 15){
                        ForEach(cities){ city in
                            NavigationLink(destination: MainView(city: city)){
                                CityPost(city: city)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                //Image("weatherWizLogo").resizable().frame(width: 300, height: 100)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        showAddCityWindow = true
                    }label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Button{
                        showLoginSheet = true
                    }label: {
                        Image(systemName: "person.crop.circle")
                    }
                }
            }
            .sheet(isPresented: $showAddCityWindow){
                // Safely unwrap the user to pass into AddNewCityView; if nil, present nothing
                if let user = loggedInUser {
                    AddNewCityView(user: user)
                } else {
                    Text("Please log in to add cities.")
                        .padding()
                }
            }
            .sheet(isPresented: $showLoginSheet) {
                LoginView(loggedInUser: $loggedInUser)
            }
        }
    }
}

struct Title: View{
    var body: some View{
        Text("Weather Board").font(Font.largeTitle).bold()
    }
}

struct CityPost: View{
    let city: City
    let cityName: String
    let bgColor: Color
    let dotColor: Color
    let width: CGFloat
    let height: CGFloat
    
    init(city: City, bgColor: Color = .yellow, dotColor: Color = .red, width: CGFloat = 150, height: CGFloat = 150){
        self.city = city
        self.cityName = city.cityName
        self.bgColor = bgColor
        self.dotColor = dotColor
        self.width = width
        self.height = height
    }
    
    var body: some View{
        VStack{
            Circle().fill(dotColor).frame(width: 15).padding(.bottom, 25)
            Text("\(cityName),").font(Font.title)
            Text(city.countryName).font(Font.title)
            Text("")
            
        }.frame(width: width, height: height).padding(20).background(bgColor).border(Color.black)
    }
}

#Preview {
    // Example preview with a constant binding
    WeatherBoardView(
        cities: [],
        loggedInUser: .constant(UserPreferences(username: "PreviewUser"))
    )
}

