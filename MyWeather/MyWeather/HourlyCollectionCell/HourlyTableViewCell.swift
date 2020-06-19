//
//  HourlyTableViewCell.swift
//  MyWeather
//
//  Created by Jonathan Shoemaker on 6/18/20.
//  Copyright © 2020 JonathanShoemaker. All rights reserved.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
}
