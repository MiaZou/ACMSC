//
//  WeatherInputViewController.swift
//  ACMSC
//
//  Created by Mia Zou on 6/2/23.
//

import UIKit

class WeatherInputViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let timeDropdownData = ["0", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    
    var specialPattern: Int = 0
    var date: String = ""
    var selectedTime: Int = 0
    var selectedWeatherType: Int = 0
    var weatherType: WeatherTypeModel = WeatherTypeModel(time: 0, weather: 0)
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var specialPatternsNoData: UIButton!
    @IBOutlet weak var specialPatternsMeteorShower: UIButton!
    @IBOutlet weak var specialPatternsNone: UIButton!
    
    @IBOutlet weak var timeDropdownButton: UIButton!
    @IBOutlet weak var weatherDropdownButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        specialPatternsNoData.addTarget(self, action: #selector(noDataTapped), for: .touchUpInside)
        specialPatternsMeteorShower.addTarget(self, action: #selector(meteorShowerTapped), for: .touchUpInside)
        specialPatternsNone.addTarget(self, action: #selector(noneTapped), for: .touchUpInside)
        
        specialPatternsNoData.layer.borderColor = UIColor.systemBlue.cgColor
        specialPatternsNoData.layer.borderWidth = 2.0
        specialPatternsMeteorShower.layer.borderColor = UIColor.clear.cgColor
        specialPatternsMeteorShower.layer.borderWidth = 0.0
        specialPatternsNone.layer.borderColor = UIColor.clear.cgColor
        specialPatternsNone.layer.borderWidth = 0.0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        date = dateFormatter.string(from: Date())
        
        timeDropdownButton.isSelected = false
        weatherDropdownButton.isSelected = false

        timeDropdownButton.addTarget(self, action: #selector(timeDropdownButtonTapped), for: .touchUpInside)
        weatherDropdownButton.addTarget(self, action: #selector(weatherDropdownButtonTapped), for: .touchUpInside)
    }
    
    @objc private func noDataTapped() {
        specialPattern = 0
        specialPatternsNoData.layer.borderColor = UIColor.systemBlue.cgColor
        specialPatternsNoData.layer.borderWidth = 2.0
        specialPatternsMeteorShower.layer.borderColor = UIColor.clear.cgColor
        specialPatternsMeteorShower.layer.borderWidth = 0.0
        specialPatternsNone.layer.borderColor = UIColor.clear.cgColor
        specialPatternsNone.layer.borderWidth = 0.0
    }

    @objc private func meteorShowerTapped() {
        specialPattern = 1
        specialPatternsNoData.layer.borderColor = UIColor.clear.cgColor
        specialPatternsNoData.layer.borderWidth = 0.0
        specialPatternsMeteorShower.layer.borderColor = UIColor.systemBlue.cgColor
        specialPatternsMeteorShower.layer.borderWidth = 2.0
        specialPatternsNone.layer.borderColor = UIColor.clear.cgColor
        specialPatternsNone.layer.borderWidth = 0.0
    }
    
    @objc private func noneTapped() {
        specialPattern = 2
        specialPatternsNoData.layer.borderColor = UIColor.clear.cgColor
        specialPatternsNoData.layer.borderWidth = 0.0
        specialPatternsMeteorShower.layer.borderColor = UIColor.clear.cgColor
        specialPatternsMeteorShower.layer.borderWidth = 0.0
        specialPatternsNone.layer.borderColor = UIColor.systemBlue.cgColor
        specialPatternsNone.layer.borderWidth = 2.0
    }
    
    @objc func timeDropdownButtonTapped() {
        weatherDropdownButton.isSelected = false
        timeDropdownButton.isSelected = true
        showDropdownPicker(data: timeDropdownData, for: timeDropdownButton)
    }

    @objc func weatherDropdownButtonTapped() {
        timeDropdownButton.isSelected = false
        weatherDropdownButton.isSelected = true
        showDropdownPicker(data: weathertype, for: weatherDropdownButton)
    }
    
    func showDropdownPicker(data: [String], for button: UIButton) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self

        let alertController = UIAlertController(title: nil, message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alertController.view.addSubview(pickerView)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    @objc func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @objc func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if timeDropdownButton.isSelected {
            return 24
        } else if weatherDropdownButton.isSelected {
            return weathertype.count
        } else {
            return 0
        }
    }
    
    @objc func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if timeDropdownButton.isSelected {
            weatherType.time = row
            return timeDropdownData[row]
        } else if weatherDropdownButton.isSelected{
            weatherType.weather = row
            return weathertype[row]
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if timeDropdownButton.isSelected {
            timeDropdownButton.setTitle(timeDropdownData[row], for: .normal)
        } else if weatherDropdownButton.isSelected {
            weatherDropdownButton.setTitle(weathertype[row], for: .normal)
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        Task {
            do {
                try await addWeatherData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func addWeatherData() async throws -> Void {
        // TODO: change uid
        let uid = "g8ZqFdPgmBYDxHHVgKTYC1jVLKr2"
        let url = URL(string: Configuration.apiUrl + "/weatherdata/" + uid)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let params = WeatherDataModel(date: date, specialPattern: specialPattern, weatherTypes: [weatherType])
        // ["date": date, "specialPattern": specialPattern, "weatherTypes": [weatherType]] as [String : Any]
        do {
            let jsonData = try JSONEncoder().encode(params)
            request.httpBody = jsonData
        } catch {
            print("json error here")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                _ = String(data: data, encoding: .utf8)
                print("Success!")
            }
        }
        
        task.resume()
    }
}
