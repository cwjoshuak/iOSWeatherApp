//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Joshua Kuan on 4/8/22.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    static let identifier = "WeatherCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with model: Hourly) {
        self.tempLabel.text = "\(Int(model.temp))°"
        self.imgView.contentMode = .scaleAspectFit
        self.timeLabel.text = Date(timeIntervalSince1970: Double(model.dt)).getHourForDate()
        downloadImg(iconString: model.weather[0].icon) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.imgView.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
