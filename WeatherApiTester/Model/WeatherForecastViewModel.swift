//
//  WeatherForecastViewModel.swift
//  WeatherApiTester
//
//  Created by Teboho Mohale on 2023/08/08.
//

import Foundation
import SwiftUI

class WeatherForecastViewModel: ObservableObject {
    @Published var searchText = ""
       @Published var isShowingSuggestions = false // Add this line
       @Published var weatherForecastAPI: WeatherSearchAPI?
       @Published var savedCities: [String] = []
    
    func getWeatherForecast(city: String) {
        WeatherAPIManager.getArea(searchText: city) { apiResponse in
            self.weatherForecastAPI = apiResponse
        }
    }
    
 
    
    func formatTime(_ timeString: String) -> String {
        var completeTime = timeString
        
        while completeTime.count < 4 {
            completeTime = "0" + completeTime
        }
        
        
        let index = completeTime.index(completeTime.startIndex, offsetBy: 2)
        return "\(completeTime[..<index]):\(completeTime[index...])"
    }
    

    func addCity(_ city: String) {
        savedCities.append(city)
        searchText = " "
    }
    
    func removeCity(_ city: String) {
        if let index = savedCities.firstIndex(of: city) {
            savedCities.remove(at: index)
        }
    }
    
    func removeCities(at offsets: IndexSet) {
        savedCities.remove(atOffsets: offsets)
    }
    
    func navigateToCityListView() {
        let cityListView = CityListView(savedCities: savedCities)
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.present(UIHostingController(rootView: cityListView), animated: true, completion: nil)
        }
    }
    
    func formatDateToDay(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    func dismissCityListView() {
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.dismiss(animated: true, completion: nil)
        }
    }


    func deleteCity(at offsets: IndexSet) {
        savedCities.remove(atOffsets: offsets)
    }
    
    func weatherConditionToEmoji(_ condition: String) -> String {
        switch condition {
        case "Clear":
            return "☀️"
        case "Partly cloudy":
            return "🌤"
        case "Cloudy":
            return "☁️"
        case "Rain":
            return "🌧"
        case "Snow":
            return "❄️"
        case "Thunderstorm":
            return "⛈"
        case "Fog":
            return "🌫"
        case "Mist":
            return "🌁"
        case "Haze":
            return "🌥"
        case "Drizzle":
            return "🌦"
        case "Showers":
            return "🌦☔️"
        case "Sleet":
            return "🌨❄️"
        case "Freezing rain":
            return "❄️🌧"
        case "Tornado":
            return "🌪"
        case "Hurricane":
            return "🌀"
        case "Dust":
            return "🌬"
        case "Smoke":
            return "🌫💨"
        case "Sandstorm":
            return "🌪🏜"
        case "Windy":
            return "💨"
        case "Cold":
            return "❄️"
        case "Hot":
            return "🔥"
        case "Mostly clear":
            return "🌤"
        case "Partly sunny":
            return "🌥"
        case "Mostly cloudy":
            return "🌥☁️"
        default:
            return "❓" // Unknown condition
        }
    }
    
    
}
