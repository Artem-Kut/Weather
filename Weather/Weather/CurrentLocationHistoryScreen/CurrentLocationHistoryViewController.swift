//
//  CurrentLocationHistoryViewController.swift
//  Weather
//
//  Created by Artem Kutasevych on 9/18/24.
//

import UIKit


class CurrentLocationHistoryViewController: UIViewController {
    private let viewModel: CurrentLocationHistoryViewModel
    
    private lazy var button: UIButton = {
        let but = UIButton()
        but.backgroundColor = .gray
        but.translatesAutoresizingMaskIntoConstraints = false
        but.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        but.setTitle("Go to search", for: .normal)
        return but
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var weatherDescription: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(viewModel: CurrentLocationHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        setupAutoLayout()
    }
    
    
    func setupSubviews() {
        view.addSubview(cityLabel)
        view.addSubview(weatherLabel)
        view.addSubview(weatherDescription)
        view.addSubview(imageView)
        view.addSubview(button)
    }
    
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cityLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            weatherLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weatherLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weatherLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
        
            weatherDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weatherDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weatherDescription.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 24),
            
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
        ])
    }
    
    func update() {
        cityLabel.text = viewModel.weather?.name
        weatherLabel.text = viewModel.weather?.weather.first?.main
        weatherDescription.text = viewModel.weather?.weather.first?.description
        if let url = viewModel.weather?.weather.first?.iconURL {
            imageView.imageFrom(url: url)
        }
    }
    
    @objc private func buttonClicked() {
        viewModel.goToSearch()
    }
}

