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
//35 replace weather with DailyWeatherEntry
var models = [DailyWeatherEntry]()
    
//17 create a LocationManager
    let locationManager = CLLocationManager()
//19 need another property to capture current coordinates of the user. we can use New York for the TEST
    var currentLocation: CLLocation?
//66 create current to get currentWeather
    var current: CurrentWeather?
    
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
//71 set Tables background view to the saem from step 69 and 70
        table.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        view.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)

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
        let url = "https://api.darksky.net/forecast/ddcc4ebb2a7c9930b90d9e59bda0ba7a/\(lat),\(long)?exclude=[flags,minutely]"
//29 now a URLSession will make the actual request.
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
 //30 in here we need validation and convert data into models/some object to use in code, we also need to update user interface
//31 here is easy validation
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
//32 convert data to models/some object with JSOn Decoder
//36 Now that we've defined model we are going o decode response data with a do catch statement which tries to use JSON decoder
            var json: WeatherResponse?
            do {
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
            }
            catch {
                print("error: \(error)")
            }
//38 is do catch is successful. and with this, we should get a printed statement claiming partly cloudy
            guard let result = json else {
                return
            }
 //39 get rid of print statement and now we need list of daily entries for updating our models array and reloading table view
            let entries = result.daily.data
            
            self.models.append(contentsOf: entries)
//65 we are gonna assign current weather data to a property so we can access it. create a var for currentWeather above
            let current = result.currently
            self.current = current
//40 update User Interface to tell program that the stuff in this isnt on main thread. for faster reload
            DispatchQueue.main.async {
                self.table.reloadData()
//57 now we create table Header by making up a function to call
                self.table.tableHeaderView = self.createTableHeader()
            }
 //           print(result.currently.summary)
//37 for the request to fire off we need a .resume at the end of it
            }).resume()
        
        
        print("\(long) | \(lat)")
//24 after we write this go to info.plist and write a string required by apple when requesting any permission. add Privacy Location When in Use and the String = Please Allow location to see local weather
//25 also go to features/location/apple and set that
    }
    
//58 createTableHeader func can go here
    func createTableHeader() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
//59 create a red space jus tto see where our current temp will go
//69 now we can get rid of RED color and set up a nice background color. search hex on google for color RGB
   //     headerView.backgroundColor = .red
        headerView.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
//60 create our three labels for current temp (these are all specific to the Youtube video. not only specific to any given app)
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height+summaryLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/2))
//62 make sure these come off as subviews
        headerView.addSubview(locationLabel)
        headerView.addSubview(summaryLabel)
        headerView.addSubview(tempLabel)
//63 now center the sub labels
        tempLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
        locationLabel.textAlignment = .center
//61 assign dummy text
//64 now adjust the sizes
//67 now text for temp and summary can be current temp. be sure to wrap in text block
//68 we get a string interpolation warning because current is optional "?" so lets unwrap it and replace tempLabel.text = "\(self.current?.temperature)°" with currentWeather
        guard let currentWeather = self.current else {
            return UIView()
        }
        tempLabel.text = "\(currentWeather.temperature)°"
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        locationLabel.text = "Current Location"
        summaryLabel.text = self.current?.summary
        
        return headerView
    }
    
    
//11 we also need to implement table func numberOfRows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
//12 now a func cellForRow and for now return UITableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//41 now we need to implement the weather cell (later the hourly). right click on WeatherTableViewCell and jump to definition. then add a func to configure the cell "func configure(with model: DailyWeatherEntry) {}"
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
//43 now we call that func within the definition
        cell.configure(with: models[indexPath.row])
//70 set the background color from step 69 to background of cell
        cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        return cell
    }
//53 now we set ehgiht of the row cells to give us more space
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//8 create the struct just to avoid errors at first. So an empty struct here
//33 create a codable weather struct (replacing an empty Weather struct) for JSOn Decoder. Will delete thios weather struct and instea duse one we copied from the api
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
//34 our table is gonna show a list of daily items, so we are going to put this into our model.
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
