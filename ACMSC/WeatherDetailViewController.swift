//
//  WeatherDetailViewController.swift
//  ACMSC
//
//  Created by Mia Zou on 6/16/23.
//

import UIKit

class WeatherDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let weathertype = ["Clear/Fine", "Sunny", "Cloudy", "Rain/Snow Clouds", "Rain/Snow", "Heavy Rain/Snow"]
    let specialPatterns = ["None of above", "Meteor shower or visit from Celeste", "No data"]
    
    @IBOutlet weak var tableView: UITableView!
    var weatherDetail: WeatherDataModel = WeatherDataModel(date: "", specialPattern: 0, weatherTypes: [])
    
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
            return specialPatterns[weatherDetail.specialPattern]
        } else if section == 2 {
            return "Possible Weather"
        } else {
            return "Weather"
        }
    }

}
