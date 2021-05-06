//
//  Weather.swift
//  mvvm_weather_app
//
//  Created by Gerwin on 04.04.21.
//

import Foundation

struct Weather: Decodable {
    let coord: CoordData
    let weather: [WeatherData]
    let base: String
    let main: MainData
    let visibility: Int
    let wind: WindData
    let clouds: CloudsData
    let dt: Int
    let sys: SysData
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct CoordData: Decodable {
    let lon: Double
    let lat: Double
}

struct WeatherData: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainData: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct WindData: Decodable {
    let speed: Double
    let deg: Int
}

struct CloudsData: Decodable {
    let all: Int
}

struct SysData: Decodable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Double
    let sunset: Double
}
