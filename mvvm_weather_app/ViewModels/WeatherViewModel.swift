//
//  WeatherViewModel.swift
//  mvvm_weather_app
//
//  Created by Gerwin on 04.04.21.
//

protocol WeatherViewModelDelegate: AnyObject {
    func isInvalidInput(_ city:String)
}

import Foundation
import UIKit

class WeatherViewModel {
    
    weak var weatherViewModelDelegate: WeatherViewModelDelegate?
    
    private var apiService : APIService!
    private(set) var weathers = Weathers(cityWeathers: []) {
        didSet {
            self.callback(weathers)
        }
    }
    
    let callback : (Weathers) -> ()
    
    init(callback: @escaping (Weathers) -> ()) {
        self.callback = callback
        self.apiService =  APIService()
    }
    
    func addCity(newCity: String?) {
        guard let city = newCity else { return }
        
        if city.isEmpty { return }
        
        self.apiService.apiToGetWeatherForecastData(city: city) {  (weatherData) in
            
            if let data = weatherData {
                let insertionIndex = self.weathers.cityWeathers.count
                self.weathers.editingStyle = .insert(data, IndexPath(item: insertionIndex, section: 0))
            } else {
                self.weatherViewModelDelegate?.isInvalidInput(city)
            }
        }
        
    }
    
    func deleteCity(atIndex indexPath: IndexPath) {
        weathers.editingStyle = .delete(indexPath)
    }
    
}
