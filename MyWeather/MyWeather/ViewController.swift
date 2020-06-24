//
//  ViewController.swift
//  MyWeather
//
//  Created by Jonathan Shoemaker on 6/18/20.
//  Copyright © 2020 JonathanShoemaker. All rights reserved.
//

import UIKit
import CoreLocation

//1 setup location with core location
//2 we need to setup a tableView
//3 we will need a custom way of showing horizontal table with hourly forecast for the current day. use custom cell with a collection view
//4 we will need an API / request to get the data
//5 now first action will be to go to assets to create icons. name images and drag and drop icons

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
//6 tableView is easiest, Do that first. set up an IBOutlet
    @IBOutlet var table: UITableView!
//7 now create an array for models of weather objects
var models = [Weather]()
    
//17 create a LocationManager
    let locationManager = CLLocationManager()
//19 need another property to capture current coordinates of the user. we can use New York for the TEST
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//10 register 2 custom cell, one for horizontal scrolling for hourly forecast. other is normal vertical for current day forecast, highs, lows, ect. REGISTER 2 CELLS
//15 now we register those 2 cells we just created. ***The Order we register cells is irrelevant as long as we register them before they are used**
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
//9 set table delegate and datasource. Add UITableViewDelegate and UITableViewDataSource to the class above
        table.delegate = self
        table.dataSource = self
        // Do any additional setup after loading the view.

    }
//26 call the setupLocation() func to make it appear. We need to create a viewDidAppear for that. Minutemakrer 14:30
//27 Dark SKY API is no longer existent. so....do the steps, and a new API will be inserted. Will try OpenWeatherMap.Org
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
//16 location Stuff will go here. Be sure to add CLLocationManager Delegate up top.
//18create setupLocation function and add in a location authorization in use prompt
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
//20 location function that we want is for didUpdateLocaions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
//21 once we have a location lets stop
            locationManager.stopUpdatingLocation()
//22 call another function called requestWeatherForLocation (which will be defined later)
            requestWeatherForLocation()
        }
    }
//23 define the func requestWeatherForLocation. at first just Longitude and Lattitude. with guard let statements to make sure its not nil
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
 //28 get the URL with request
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely&appid={3141b6b824a580737b854723c94aa7b6}"
//29 now a URLSession will make the actual request.
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
 //30 in here we need validation and convert data into models/some object to use in code, we also need to update user interface
//31 here is easy validation
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
//32 convert data to models/some object with JSOn Decoder
        })
        
        
        print("\(long) | \(lat)")
//24 after we write this go to info.plist and write a string required by apple when requesting any permission. add Privacy Location When in Use and the String = Please Allow location to see local weather
//25 also go to features/location/apple and set that
    }
    
    
//11 we also need to implement table func numberOfRows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
//12 now a func cellForRow and for now return UITableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

//8 create the struct just to avoid errors at first. So an empty struct here
//33 create a codable weather struct for JSOn Decoder. Will delete thios weather struct and instea duse one we copied from the api
struct WeatherResponse: Codable {
    let latitude: Float
    let longitude: Float
    let timezone: String
    let currently: CurrentWeather
    let hourly: HourlyWeather
    let daily: DailyWeather
    let offset: Float
}

struct CurrentWeather: Codable {
    let time: Int
    let summary: String
    let icon: String
    let nearestStormDistance: Int
    let nearestStormBearing: Int
    let precipIntensity: Int
    let precipProbability: Int
    let temperature: Double
    let apparentTemperature: Double
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let visibility: Double
    let ozone: Double
}

struct DailyWeather: Codable {
    let summary: String
    let icon: String
    let data: [DailyWeatherEntry]
}

struct DailyWeatherEntry: Codable {
    let time: Int
    let summary: String
    let icon: String
    let sunriseTime: Int
    let sunsetTime: Int
    let moonPhase: Double
    let precipIntensity: Float
    let precipIntensityMax: Float
    let precipIntensityMaxTime: Int
    let precipProbability: Double
    let precipType: String?
    let temperatureHigh: Double
    let temperatureHighTime: Int
    let temperatureLow: Double
    let temperatureLowTime: Int
    let apparentTemperatureHigh: Double
    let apparentTemperatureHighTime: Int
    let apparentTemperatureLow: Double
    let apparentTemperatureLowTime: Int
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windGustTime: Int
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let uvIndexTime: Int
    let visibility: Double
    let ozone: Double
    let temperatureMin: Double
    let temperatureMinTime: Int
    let temperatureMax: Double
    let temperatureMaxTime: Int
    let apparentTemperatureMin: Double
    let apparentTemperatureMinTime: Int
    let apparentTemperatureMax: Double
    let apparentTemperatureMaxTime: Int
}

struct HourlyWeather: Codable {
    let summary: String
    let icon: String
    let data: [HourlyWeatherEntry]
}

struct HourlyWeatherEntry: Codable {
    let time: Int
    let summary: String
    let icon: String
    let precipIntensity: Float
    let precipProbability: Double
    let precipType: String?
    let temperature: Double
    let apparentTemperature: Double
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let visibility: Double
    let ozone: Double
}
