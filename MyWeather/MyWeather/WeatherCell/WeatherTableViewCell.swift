//
//  WeatherTableViewCell.swift
//  MyWeather
//
//  Created by Jonathan Shoemaker on 6/18/20.
//  Copyright © 2020 JonathanShoemaker. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//14 use the same structure as we used in HourlyTableViewCell.swift
    static let identifier = "WeatherTableViewCell"
    static func nib() -> UINib {
    return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
}
