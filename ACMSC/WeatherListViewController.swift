////
//  WeatherListViewController.swift
//  ACMSC
//
//  Created by Mia Zou on 6/2/23.
//
//
import UIKit
import Foundation

class WeatherListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var userData: UserDataModel! = nil
    var weatherData: [WeatherDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        weatherData = userData?.weatherData ?? []
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return weatherData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let weatherDataItem = weatherData[indexPath.section]
        cell.textLabel?.text = weatherDataItem.date

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weatherDetail = weatherData[indexPath.section]
        performSegue(withIdentifier: "weatherDetailClicked", sender: weatherDetail)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "weatherDetailClicked" {
            let weatherDetailViewController = segue.destination as! WeatherDetailViewController
            if let passedData = sender as? WeatherDataModel {
                weatherDetailViewController.weatherDetail = passedData
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Weather Data"
    }
    
}
