//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Artem Kutasevych on 9/17/24.
//

import Foundation
import Combine

class WeatherViewModel {
    private var cancellables = Set<AnyCancellable>()
    private let weatherService: WeatherServiceProtocol
    weak var view: WeatherViewControllerUpdatable?
    var weather: WeatherData?
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    func findWeather(for city: String) {
        weatherService.getWeatherCity(city: city)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                self.weather = response
                UserDefaults.standard.setValue(self.weather?.name, forKey: "city")
                self.view?.update()
            })
            .store(in: &cancellables)
    }
}
