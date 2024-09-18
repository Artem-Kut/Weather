//
//  WeatherViewController.swift
//  Weather
//
//  Created by Artem Kutasevych on 9/17/24.
//

import UIKit

protocol WeatherViewControllerUpdatable: AnyObject {
    func update()
}

class WeatherViewController: UIViewController, WeatherViewControllerUpdatable {
    private let viewModel: WeatherViewModel
    
    private lazy var textField: UITextField = {
        let text = UITextField()
        text.borderStyle = .roundedRect
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private lazy var button: UIButton = {
        let but = UIButton()
        but.backgroundColor = .gray
        but.translatesAutoresizingMaskIntoConstraints = false
        but.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        but.setTitle("Find", for: .normal)
        return but
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
    
    init(viewModel: WeatherViewModel) {
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
        view.addSubview(textField)
        view.addSubview(button)
        view.addSubview(weatherLabel)
        view.addSubview(weatherDescription)
        view.addSubview(imageView)
    }
    
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            textField.widthAnchor.constraint(equalToConstant: 24),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            button.heightAnchor.constraint(equalToConstant: 24),
            
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            weatherLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weatherLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weatherLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
        
            weatherDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weatherDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weatherDescription.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 24),
        ])
    }
    
    
    
    private func setUpConstraints() {
        let sampleLabelConstraints = [
            self.weatherLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.weatherLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(sampleLabelConstraints)
    }
    
    func update() {
        weatherLabel.text = viewModel.weather?.weather.first?.main
        weatherDescription.text = viewModel.weather?.weather.first?.description
        if let url = viewModel.weather?.weather.first?.iconURL {
            imageView.imageFrom(url: url)
        }
    }
    
    @objc private func buttonClicked() {
        guard let city = textField.text else { return }
        viewModel.findWeather(for: city)
    }
}

extension UIImageView {
    func imageFrom(url:URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data:data){
                    DispatchQueue.main.async{
                        self?.image = image
                    }
                }
            }
        }
    }
}
