//
//  Utils.swift
//  WeatherApp
//
//  Created by Joshua Kuan on 4/8/22.
//

import Foundation
import UIKit
func downloadImg(iconString: String, _ completion: @escaping ((Result<UIImage, Error>) -> Void)) {
    let baseURL = "https://openweathermap.org/img/wn/"

    URLSession.shared.dataTask(with: URL(string: baseURL+"\(iconString)@2x.png")!) { data, _, error in
        
        if let data = data, error == nil {
            completion(.success(UIImage(data: data)!))
            
        } else {
            completion(.failure(DownloadImageError.dataCorrupt))
        }
    }.resume()
}

enum DownloadImageError: Error {
    case dataCorrupt
}
