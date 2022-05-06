//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Joshua Kuan on 4/7/22.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    func configure(with model: Daily) {
        self.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)

        lowTempLabel.text = "\(Int(model.temp.min))°"
        lowTempLabel.textAlignment = .center
        
        highTempLabel.text = "\(Int(model.temp.max))°"
        highTempLabel.textAlignment = .center
        
        dayLabel.text = Date(timeIntervalSince1970: Double(model.dt)).getDayForDate() 
        if !model.weather.isEmpty {
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

        imgView.contentMode = .scaleAspectFit
    }

}
