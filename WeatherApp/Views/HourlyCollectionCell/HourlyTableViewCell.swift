//
//  HourlyTableViewCell.swift
//  WeatherApp
//
//  Created by Joshua Kuan on 4/7/22.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {

    @IBOutlet var collectionView: UICollectionView!
    var models = [Hourly]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(WeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: "WeatherCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "HourlyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "HourlyTableViewCell", bundle: nil)
    }
    func configure(with models: [Hourly]) {
        self.models = models
        collectionView.reloadData()
    }
}

extension HourlyTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 70, height: 100)
    }
}
