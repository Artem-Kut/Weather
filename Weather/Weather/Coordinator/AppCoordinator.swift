//
//  AppCoordinator.swift
//  Weather
//
//  Created by Artem Kutasevych on 9/17/24.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
    
}

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    let serviceLayer: WeatherService
    
    init(navigationController: UINavigationController, serviceLayer: WeatherService) {
        self.navigationController = navigationController
        self.serviceLayer = serviceLayer
    }
    
    func start() {
//        let viewModel = WeatherViewModel(weatherService: serviceLayer)
//        let weatherVC = WeatherViewController(viewModel: viewModel)
//        viewModel.view = weatherVC
//                navigationController.pushViewController(weatherVC, animated: false)
        
        let viewModel = CurrentLocationHistoryViewModel(weatherService: serviceLayer) { [weak self] in
            self?.showSearch()
        }
        let locationVC = CurrentLocationHistoryViewController(viewModel: viewModel)
        viewModel.view = locationVC
        navigationController.pushViewController(locationVC, animated: false)
    }
    
    func showSearch() {
        let viewModel = WeatherViewModel(weatherService: serviceLayer)
        let weatherVC = WeatherViewController(viewModel: viewModel)
        viewModel.view = weatherVC
        navigationController.pushViewController(weatherVC, animated: false)
    }
}
