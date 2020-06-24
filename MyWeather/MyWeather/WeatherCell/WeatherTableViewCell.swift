//
//  WeatherTableViewCell.swift
//  MyWeather
//
//  Created by Jonathan Shoemaker on 6/18/20.
//  Copyright © 2020 JonathanShoemaker. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
//45 add outlet for day label, high temp label, low temp lable, and an icon image view
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//44 set up a background color to help distiguish cells
//55 now get rid of background color
       // backgroundColor = .gray
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
//42 add func here from step 41
    func configure(with model: DailyWeatherEntry) {
//54 now we should increase the size of the Temp Lables and center them
        self.highTempLabel.textAlignment = .center
        self.lowTempLabel.textAlignment = .center
        
 //46 configure cell with model and assign all the IBOutlets. convert temps to an Int and then put them in a string. '''it goes from model.temperatureLow to Int(model.temperatureLow) to what comes out in the end''' also need to copy paste the little degree symbol. on windows keyboard with mac its alt+shift+8 °
        self.lowTempLabel.text = "\(Int(model.temperatureLow))°"
        self.highTempLabel.text = "\(Int(model.temperatureHigh))°"
//47 now we want to configure the day we are showing. using another function getDayForDate
        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.time)))
//51 for now default the icon to the sun icon. Then go to weatherCells.xib for next steps (cant take notes) TimeStamp 33 minutes into the video on youtube
//56 now we will compute the correct icon. After this step Build and it should show diff icons
       //this was temporary from step 51 self.iconImageView.image = UIImage(named: "clear")
        let icon = model.icon.lowercased()
        if icon.contains("clear") {
            self.iconImageView.image = UIImage(named: "clear")
        }
        else if icon.contains("rain") {
            self.iconImageView.image = UIImage(named: "rain")
        }
        else {
            self.iconImageView.image = UIImage(named: "cloud")
        }
 //52 increase size of cell height and set property which is gonna be this
        self.iconImageView.contentMode = .scaleAspectFit
    }
//48 create the date function. make Date optional cause we are trying to initialize date and it might fail.
    func getDayForDate(_ date: Date?) -> String {
//49 retiurn a string
        guard let inputDate = date else {
            return ""
        }
//50 use a dateFormat to give us more control over nsDateFormatter
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" //Monday
        return formatter.string(from: inputDate)
    }
    
}
