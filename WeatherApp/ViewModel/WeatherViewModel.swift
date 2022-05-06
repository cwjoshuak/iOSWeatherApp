//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Joshua Kuan on 5/5/22.
//

import Foundation

class WeatherViewModel {
    
    var daily = [Daily]()
    var hourly = [Hourly]()
    var currentWeather: CurrentWeather?
    var delegate: WeatherViewModelProtocol?
    
    
    func fetchData(lat: Double, long: Double, completionHandler: ((Bool)->Void)? = nil) {
        #warning("REPLACE API KEY BELOW AND REMOVE THIS LINE")
        let api_key = "REPLACE WITH YOUR API KEY HERE"
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&units=imperial&appid=\(api_key)"
        let dataTask = URLSession.shared.dataTask(with: URL(string: url)!) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let weatherData = try JSONDecoder().decode(WeatherResponse.self, from: data)
                guard let weatherDaily = weatherData.daily, let weatherHourly = weatherData.hourly else {
                    completionHandler?(false)
                    return
                }
                self?.daily = weatherDaily
                self?.hourly = weatherHourly
                self?.currentWeather = weatherData.current
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.refreshUI()
                }
                completionHandler?(true)
            } catch {
                print("error: \(error)")
            }
            
        }
        dataTask.resume()
    }
    
    func dailyCount() -> Int {
        return daily.count
    }
    
}

protocol WeatherViewModelProtocol {
    func refreshUI()
}
