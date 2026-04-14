//
//  WeatherBoardView.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-03-20.
//

import SwiftUI

struct WeatherBoardView: View {
    var cities: [City]
    @State var search: String = ""
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())] //Used for the LazyVGrid
    
    //@ViewBuilder
    var body: some View {
        
        //var numCities = 5
       
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
            Text("BC").font(Font.title)
            Text("")
            
        }.frame(width: width, height: height).padding(20).background(bgColor).border(Color.black)
    }
}

#Preview {
    //WeatherBoardView(cities: ["Kelowna", "Vancouver", "Tokyo", "a", "b", "c"])
}
