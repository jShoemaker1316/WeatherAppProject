//
//  WeatherCollectionViewCell.swift
//  MyWeather
//
//  Created by Jonathan Shoemaker on 6/24/20.
//  Copyright © 2020 JonathanShoemaker. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
//78 lets create an identifier for this new file shown created at 5:30 in the PART 2 video
   static let identifier = "WeatherCollectionViewCell"
 //79 now return the nib with new name, same as identifier
    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
    }
 //80 create a couple of outlets for image and label
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
//81 now add configure func that takes in a single hourly weather entry. Be sure to wrap the text in a string
    func configure(with model: HourlyWeatherEntry) {
        self.tempLabel.text = "\(model.temperature)"
//82 set "clear for now and also set to aspect FIT. Then go actually configure the XIB for this file
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconImageView.image = UIImage(named: "clear")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
