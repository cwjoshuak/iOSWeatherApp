//
//  Date+Extensions.swift
//  WeatherApp
//
//  Created by Joshua Kuan on 5/5/22.
//

import Foundation

extension Date {
    func getDayForDate() -> String {
//        guard let date = self else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
    func getHourForDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: self)
    }
}
