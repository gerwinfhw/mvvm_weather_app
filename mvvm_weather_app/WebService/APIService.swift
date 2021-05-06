//
//  APIService.swift
//  mvvm_weather_app
//
//  Created by Gerwin on 04.04.21.
//

import Foundation

class APIService {
    
    private let weather_api_key = "4f3dbea5a7866dfe39ee7d6a158d49fb"
    
    private func buildURL(for city:String, units:String = "metric", lang:String = "de") -> String {
        var formatString = city.replacingOccurrences(of: "ä", with: "ae")
        formatString = formatString.replacingOccurrences(of: "ö", with: "oe")
        formatString = formatString.replacingOccurrences(of: "ü", with: "ue")
        formatString = formatString.replacingOccurrences(of: " ", with: "%20")
        
        let api = "https://api.openweathermap.org"
        let endpoint = "/data/2.5/weather?q=\(formatString)&units=\(units)&lang=\(lang)&appid=\(weather_api_key)"
        
        return api + endpoint
    }
    
    
    func apiToGetWeatherForecastData(city: String, completion : @escaping (Weather?) -> ()){
        let url = URL(string: buildURL(for: city))!
        
        URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            
            if let data = data {
                
                let jsonDecoder = JSONDecoder()
                do {
                    let empData = try jsonDecoder.decode(Weather.self, from: data)
                    completion(empData)
                } catch {
                    completion(nil)
                }
            }
            
        }.resume()
        
    }
    
    
}
