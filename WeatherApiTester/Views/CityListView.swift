//
//  CityListView.swift
//  WeatherApiTester
//
//  Created by Teboho Mohale on 2023/08/01.
//

import SwiftUI

struct CityListView: View {
    @State var savedCities: [String]
    @StateObject private var viewModel = WeatherForecastViewModel()

    var body: some View {
        List {
            ForEach(savedCities, id: \.self) { city in
                Text(city)
            }
            .onDelete(perform: viewModel.removeCities)
        }
        .navigationTitle("City List")
        .navigationBarItems(trailing:
            Button(action: {
            viewModel.dismissCityListView()
            }) {
                Text("Close")
            }
        )
    }
    

}

