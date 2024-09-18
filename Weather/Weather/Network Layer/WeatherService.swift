//
//  WeatherService.swift
//  Weather
//
//  Created by Artem Kutasevych on 9/17/24.
//


import Foundation
import Combine
import CoreLocation

let urlString = "https://openweathermap.org/img/wn/10@2x.png"

protocol WeatherServiceProtocol {
    func getWeather(with coordinate: CLLocationCoordinate2D) -> AnyPublisher<WeatherData, Error>
    func getWeatherCity(city: String) -> AnyPublisher<WeatherData, Error>
}

class WeatherService: WeatherServiceProtocol {
    
    func getWeather(with coordinate: CLLocationCoordinate2D)  -> AnyPublisher<WeatherData, Error> {
        let apiClient = URLSessionAPIClient<WeatherEndpoint>()
        return apiClient.request(.getWeather(location: coordinate))
    }
    
    func getWeatherCity(city: String) -> AnyPublisher<WeatherData, any Error> {
        let apiClient = URLSessionAPIClient<WeatherEndpoint>()
        return apiClient.request(.getWeatherCity(city: city))
    }
}

struct WeatherData: Codable {
    let weather: [Weather]
    let name: String
}

struct Weather: Codable {
    let main: String
    let description: String
    private let icon: String
    let iconURL: URL?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.main = try container.decode(String.self, forKey: .main)
        self.description = try container.decode(String.self, forKey: .description)
        self.icon = try container.decode(String.self, forKey: .icon)
        let urlString =  urlString.replacingOccurrences(of: "10", with: self.icon)
        if let url = URL(string: urlString) {
            self.iconURL = url
        } else {
            self.iconURL = nil
        }
       
    }
}
