//
//  CurrentLocationHistoryViewModel.swift
//  Weather
//
//  Created by Artem Kutasevych on 9/18/24.
//

import Foundation
import Combine
import CoreLocation

class CurrentLocationHistoryViewModel: NSObject {
    private var cancellables = Set<AnyCancellable>()
    private let weatherService: WeatherServiceProtocol
    let locationManager = CLLocationManager()
    weak var view: CurrentLocationHistoryViewController?
    var weather: WeatherData?
    var callback: () -> Void
    
    init(weatherService: WeatherServiceProtocol, callback: @escaping () -> Void) {
        self.weatherService = weatherService
        self.callback = callback
        super.init()
        if let city = UserDefaults.standard.object(forKey:"city") as? String {
            self.getWeather(for: city)
        } else {
            self.requestLocation()
        }
    }
    
    func goToSearch() {
        callback()
    }
    
    private func requestLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    private func findWeather(for location: CLLocationCoordinate2D) {
        weatherService.getWeather(with: location)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                self.weather = response
                self.view?.update()
            })
            .store(in: &cancellables)
    }
    
    private func getWeather(for city: String) {
        weatherService.getWeatherCity(city: city)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                self.weather = response
                self.view?.update()
            })
            .store(in: &cancellables)
    }
    
}

extension CurrentLocationHistoryViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation

        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        let coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        findWeather(for: coordinate)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}
