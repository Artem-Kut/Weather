//
//  WeatherEndpoint.swift
//  Weather
//
//  Created by Artem Kutasevych on 9/17/24.
//

import Foundation
import CoreLocation

enum WeatherEndpoint: APIEndpoint {
   
    case getWeather(location: CLLocationCoordinate2D)
    case getWeatherCity(city: String)
    
    
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather")!
    }
    
    
    var path: String {
        switch self {
        case .getWeather, .getWeatherCity:
            return ""
        }
    }
    var method: HTTPMethod {
        switch self {
        case .getWeather, .getWeatherCity:
            return .get
        }
    }
    var headers: [String: String]? {
        return nil
    }
    var parameters: [String: Any]? {
        var parametersIn = [String: Any]()
        
        switch self {
        case .getWeather(let location):
            parametersIn["lat"] = "\(location.latitude)"
            parametersIn["lon"] = "\(location.longitude)"
        case .getWeatherCity(let city):
            parametersIn["q"] = city
        }
        parametersIn["appid"] = "6f1add474cad63606f96c08f59e16049"
        return parametersIn
    }
}
