//
//  WeatherDetailViewController.swift
//  ACMSC
//
//  Created by Mia Zou on 6/16/23.
//

import UIKit

//extension WeatherData {
//    static let sampleWeatherData: [WeatherData] = [
//        WeatherData(date: "05-28-2023", specialPatterns: 0, weatherTypes: [WeatherType(time: 9, weather: 0), WeatherType(time: 10, weather: 0)]),
//        WeatherData(date: "05-29-2023", specialPatterns: 1, weatherTypes: [WeatherType(time: 9, weather: 0), WeatherType(time: 10, weather: 0)]),
//        WeatherData(date: "06-01-2023", specialPatterns: 2, weatherTypes: [WeatherType(time: 9, weather: 0), WeatherType(time: 10, weather: 0)])
//    ]
//
//    static let weathertype = ["Clear/Fine", "Sunny", "Cloudy", "Rain/Snow Clouds", "Rain/Snow", "Heavy Rain/Snow"]
//
//    static let specialPatterns = ["None of above", "Meteor shower or visit from Celeste", "No data"]
//}

class WeatherDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let weathertype = ["Clear/Fine", "Sunny", "Cloudy", "Rain/Snow Clouds", "Rain/Snow", "Heavy Rain/Snow"]
    let specialPatterns = ["None of above", "Meteor shower or visit from Celeste", "No data"]
    
    @IBOutlet weak var tableView: UITableView!
    var weatherDetail: WeatherData = WeatherData(date: "05-28-2023", specialPatterns: 0, weatherTypes: [WeatherType(time: 9, weather: 0), WeatherType(time: 10, weather: 0)])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "weatherTypeDetailCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section != 3 {
            return 0
        }
        return weatherDetail.weatherTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherTypeDetailCell", for: indexPath)
        cell.textLabel?.text = " \(weatherDetail.weatherTypes[indexPath.row].time): \(weathertype[weatherDetail.weatherTypes[indexPath.row].weather])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return weatherDetail.date
        } else if section == 1 {
            return specialPatterns[weatherDetail.specialPatterns]
        } else if section == 2 {
            return "Possible Weather"
        } else {
            return "Weather"
        }
    }

}
