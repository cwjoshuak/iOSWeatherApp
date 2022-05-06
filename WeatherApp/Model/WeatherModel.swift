//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Joshua Kuan on 5/5/22.
//

import Foundation

struct WeatherResponse: Decodable {
    let lat: Float
    let lon: Float
    let timezone: String?
    let timezone_offset: Int?
    let current: CurrentWeather?
    let minutely: [Minutely]?
    let hourly: [Hourly]?
    let daily: [Daily]?
    let alerts: [Alert]?
}
struct CurrentWeather: Decodable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Float
    let feels_like: Float
    let pressure: Int
    let humidity: Int
    let dew_point: Float
    let uvi: Float
    let clouds: Int
    let visibility: Int
    let wind_speed: Float
    let wind_deg: Int
    let weather: [CurrWeatherWeather]
}
struct CurrWeatherWeather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Minutely: Decodable {
    let dt: Int
    let precipitation: Float
}
struct Hourly: Decodable {
    let dt: Int
    let temp: Float
    let feels_like: Float
    let pressure: Int
    let humidity: Int
    let dew_point: Float
    let uvi: Float
    let clouds: Int
    let visibility: Int
    let wind_speed: Float
    let wind_deg: Int
    let wind_gust: Float
    let weather: [CurrWeatherWeather]
    let pop: Float
}

struct Daily: Decodable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let moonrise: Int
    let moonset: Int
    let moon_phase: Float
    let temp: DailyTemp
    let feels_like: DailyFeelsLike
    let pressure: Int
    let humidity: Int
    let dew_point: Float
    let uvi: Float
    let clouds: Int
    let wind_speed: Float
    let wind_deg: Int
    let weather: [CurrWeatherWeather]
    let pop: Float
    let rain: Float?
}

struct DailyTemp: Decodable {
    let day: Float
    let min: Float
    let max: Float
    let night: Float
    let eve: Float
    let morn: Float
}

struct DailyFeelsLike: Decodable {
    let day: Float
    let night: Float
    let eve: Float
    let morn: Float
}

struct Alert: Decodable {
    let sender_name: String
    let event: String
    let start: Int
    let end: Int
    let description: String
    let tags: [String]
}
