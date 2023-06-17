////
//  WeatherListViewController.swift
//  ACMSC
//
//  Created by Mia Zou on 6/2/23.
//
//
import UIKit
import Foundation

struct WeatherType {
    var time: Int
    var weather: Int
}

struct WeatherData {
    var date: String
    var specialPatterns: Int
    var weatherTypes: [WeatherType]
    var possiblePatterns: Int? = nil
}

extension WeatherData {
    static let sampleWeatherData: [WeatherData] = [
        WeatherData(date: "05-28-2023", specialPatterns: 0, weatherTypes: [WeatherType(time: 9, weather: 0), WeatherType(time: 10, weather: 0)]),
        WeatherData(date: "05-29-2023", specialPatterns: 1, weatherTypes: [WeatherType(time: 9, weather: 0), WeatherType(time: 10, weather: 0)]),
        WeatherData(date: "06-01-2023", specialPatterns: 2, weatherTypes: [WeatherType(time: 9, weather: 0), WeatherType(time: 10, weather: 0)])
    ]

    static let weathertype = ["Clear/Fine", "Sunny", "Cloudy", "Rain/Snow Clouds", "Rain/Snow", "Heavy Rain/Snow"]

    static let specialPatterns = ["None of above", "Meteor shower or visit from Celeste", "No data"]
}

class WeatherListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return WeatherData.sampleWeatherData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let weatherDataItem = WeatherData.sampleWeatherData[indexPath.section]
        cell.textLabel?.text = weatherDataItem.date

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weatherDetail = WeatherData.sampleWeatherData[indexPath.section]
        performSegue(withIdentifier: "weatherDetailClicked", sender: weatherDetail)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "weatherDetailClicked" {
            let weatherDetailViewController = segue.destination as! WeatherDetailViewController
            if let passedData = sender as? WeatherData {
                weatherDetailViewController.weatherDetail = passedData
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Weather Data"
    }
    
}
