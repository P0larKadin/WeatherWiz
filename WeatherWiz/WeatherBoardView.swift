//
//  WeatherBoardView.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-03-20.
//

import SwiftUI

struct WeatherBoardView: View {
    @State var search: String = ""
    var body: some View {
        Title()
        Divider().padding()
        //var numCities = 5
        
        
        ScrollView{
            HStack{
                CityPost(cityName: "Kelowna")
                CityPost(cityName: "Vancouver", bgColor: Color.yellow)
            }
            HStack{
                CityPost(cityName: "Vernon")
                CityPost(cityName: "West Kelowna", bgColor: Color.yellow)
            }
            HStack{
                CityPost(cityName: "Peachland")
                CityPost(cityName: "Pentiction", bgColor: Color.yellow)
            }
        }
        
       
        NavigationStack{
            Text("Search Cities:").padding(.bottom, 25)
            List{
                //ForEach(WeatherData.cities, id: \.self){city in
                    //Text("Search Cities:")
                  //  Text(city)
                //}
            }.searchable(text: $search, prompt: "Search Cities:")
        }.frame(height: 150)
            .padding(.bottom, 10)
    }
}

struct Title: View{
    var body: some View{
        Text("Weather Board").font(Font.largeTitle).bold()
    }
}

struct CityPost: View{
    let cityName: String
    let bgColor: Color
    let dotColor: Color
    let width: CGFloat
    let height: CGFloat
    
    init(cityName: String, bgColor: Color = .yellow, dotColor: Color = .red, width: CGFloat = 150, height: CGFloat = 150){
        self.cityName = cityName
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
    WeatherBoardView()
}
