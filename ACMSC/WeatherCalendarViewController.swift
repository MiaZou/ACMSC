//
//  WeatherCalendarViewController.swift
//  ACMSC
//
//  Created by Mia Zou on 7/8/23.
//

struct WeatherCalendarDataModel {
    let date: String
    let pattern: Int
}

import UIKit

class WeatherCalendarViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    let exampleWeatherData: [WeatherCalendarDataModel] = [
        WeatherCalendarDataModel(date: "07032023", pattern: 1),
        WeatherCalendarDataModel(date: "07042023", pattern: 2),
        WeatherCalendarDataModel(date: "07052023", pattern: 1),
        WeatherCalendarDataModel(date: "07062023", pattern: 1),
        WeatherCalendarDataModel(date: "07072023", pattern: 0),
        WeatherCalendarDataModel(date: "07082023", pattern: 3),
        WeatherCalendarDataModel(date: "07092023", pattern: 8),
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "weatherCalendarCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return exampleWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCalendarCell", for: indexPath)
        let weatherCalendarItem = exampleWeatherData[indexPath.section]
        let patternInString: String = getPatternKind(pattern: weatherCalendarItem.pattern)
        cell.textLabel?.text = patternInString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return exampleWeatherData[section].date
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "weatherCalendarDetailSegue", sender: exampleWeatherData[indexPath.section])
    }
    
    func getPatternKind(pattern: Int) -> String {
        if pattern <= 6 { return "Fine" }
        else if pattern <= 9 { return "Cloud" }
        else if pattern <= 15 { return "Rain" }
        else if pattern <= 18 { return "FineCloud" }
        else if pattern <= 31 { return "CloudRain" }
        else if pattern <= 32 { return "Commun" }
        else { return "Event Day" }
    }
}
