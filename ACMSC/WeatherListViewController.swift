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
        
        let toolbarView = UIView()
        toolbarView.backgroundColor = .lightGray
        
        // Set the frame and autoresizing mask for the toolbar view
        toolbarView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        toolbarView.autoresizingMask = [.flexibleWidth]
        
        // Create toolbar items
        let addButton = UIButton(type: .system)
        addButton.setTitle("Add", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        let calculateButton = UIButton(type: .system)
        calculateButton.setTitle("Calculate", for: .normal)
        calculateButton.addTarget(self, action: #selector(calculateButtonTapped), for: .touchUpInside)
        
        // Add toolbar items to the toolbar view
        toolbarView.addSubview(addButton)
        toolbarView.addSubview(calculateButton)
        
        // Position the toolbar items within the toolbar view
        addButton.translatesAutoresizingMaskIntoConstraints = false
        calculateButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: toolbarView.leadingAnchor, constant: 16),
            addButton.centerYAnchor.constraint(equalTo: toolbarView.centerYAnchor),

            calculateButton.trailingAnchor.constraint(equalTo: toolbarView.trailingAnchor, constant: -16),
            calculateButton.centerYAnchor.constraint(equalTo: toolbarView.centerYAnchor)
        ])
        
        // Add the toolbar view as a subview to the main view
        view.addSubview(toolbarView)
        
        tableView.delegate = self
        tableView.dataSource = self
        weatherData = userData?.weatherData ?? []
    }
    
    @objc func addButtonTapped() {
        print("addButton tapped!")
    }
    
    @objc func calculateButtonTapped() {
        print("calculateButton tapped!")
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
