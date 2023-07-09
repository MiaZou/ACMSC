//
//  WeatherCalendarDetailViewController.swift
//  ACMSC
//
//  Created by Mia Zou on 7/9/23.
//

import UIKit

class WeatherCalendarDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let weatherPattern: Int? = nil

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
         tableView.register(UITableViewCell.self, forCellReuseIdentifier: "weatherCalendarDetailCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 24
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCalendarDetailCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.section): \(getWeather(pattern: Patterns[weatherPattern ?? 0][indexPath.section].rawValue))"

        return cell
    }
    
    func getWeather(pattern: Int) -> String {
        switch pattern {
        case 0:
            return "Clear"
        case 1:
            return "Sunny"
        case 2:
            return "Cloudy"
        case 3:
            return "RainClouds"
        case 4:
            return "Rain"
        case 5:
            return "HeavyRain"
        default:
            return "Unknown"
        }
    }
}
