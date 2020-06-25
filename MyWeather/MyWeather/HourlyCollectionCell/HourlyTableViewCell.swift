//
//  HourlyTableViewCell.swift
//  MyWeather
//
//  Created by Jonathan Shoemaker on 6/18/20.
//  Copyright © 2020 JonathanShoemaker. All rights reserved.
//

import UIKit

class HourlyTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
//72 now we start on the horizontally scrolling Hourly temps. start with adding UICollectionViewDelegate, UICollectionViewDelegateFlowLayout and UICollectionViewDATASOURCE(will create errors, click fix to create funcs) above then make some @IBOutlets
    @IBOutlet var collectionView: UICollectionView!
//75 create array for models of HourlyWeatherEntry
    var models = [HourlyWeatherEntry]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//78 need to setup collectionViews
        collectionView.dataSource = self
        collectionView.delegate = self
//83 copy over the xib info
        collectionView.register(WeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//13 add identifier and xib cells here and also on also newly created WeatherTableViewCell.swift
    static let identifier = "HourlyTableViewCell"
    static func nib() -> UINib {
    return UINib(nibName: "HourlyTableViewCell", bundle: nil)
    }
//76 add a configure func on this tableViewCell
    func configure(with models: [HourlyWeatherEntry]) {
        self.models = models
        collectionView.reloadData()
    }
//77 now size up the view cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
 //73 cut and paste the automatic funcs (from the error fix)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //74 return models.count and then create the models property
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//84 for collection item view we need to Deque this cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:WeatherCollectionViewCell.identifier, for: indexPath) as! WeatherCollectionViewCell
//85 now configure cell with current model in the array
        cell.configure(with: models[indexPath.row])
//86 now change placeholder
      //  return UICollectionViewCell()
        return cell
    }
    
    
}
