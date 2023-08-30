//
//  networkManager.swift
//  WeatherApiTester
//
//  Created by Teboho Mohale on 2023/07/28.
//

import Foundation

class WeatherAPIManager {
  static func getArea(searchText: String, completion: @escaping (WeatherSearchAPI?) -> Void) {
    guard let url = URL(string: "https://api.worldweatheronline.com/premium/v1/weather.ashx?format=json&num_of_days=5&key=60ab03581003492bb0484159232507&q=\(searchText)") else {
      completion(nil)
      return
    }
    URLSession.shared.dataTask(with: url) { data, response, error in
      if let data = data {
        if let decodedResponse = try? JSONDecoder().decode(WeatherSearchAPI.self, from: data) {
          DispatchQueue.main.async {
            completion(decodedResponse)
          }
          return
        }
      }
      print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
      completion(nil)
    }.resume()
  }
    
    // Function to get the weekly weather forecast
        static func getWeeklyWeatherForecast(searchText: String, completion: @escaping (WeatherSearchAPI?) -> Void) {
            guard let url = URL(string: "https://api.worldweatheronline.com/premium/v1/weather.ashx?format=json&num_of_days=7&key=60ab03581003492bb0484159232507&q=\(searchText)") else {
                completion(nil)
                return
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    if let decodedResponse = try? JSONDecoder().decode(WeatherSearchAPI.self, from: data) {
                        DispatchQueue.main.async {
                            completion(decodedResponse)
                        }
                        return
                    }
                }
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }.resume()
        }
}
