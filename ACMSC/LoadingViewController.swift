//
//  LoadingViewController.swift
//  ACMSC
//
//  Created by Mia Zou on 6/16/23.
//

struct WeatherTypeModel: Codable {
    var time: Int
    var weather: Int
}

struct WeatherDataModel: Codable {
    var date: String
    var specialPattern: Int
    var weatherTypes: [WeatherTypeModel]
}

struct UserDataModel: Codable {
    var uid: String
    var hemisphere: Int
    var weatherData: [WeatherDataModel]
}


import UIKit

class LoadingViewController: UIViewController {
    
    var uid: String! = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserData()
        // Do any additional setup after loading the view.
    }
    
    
    func getUserData() {
        guard uid != "" else { return }
        let url = URL(string: Configuration.apiUrl + "/weather/" + uid)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(UserDataModel.self, from: data)
                    self.directToWeatherListVC(userData: decodedData)
                } catch {
                    print(error.localizedDescription)
                    return
                }
            }
        }
        task.resume()
    }
    func directToWeatherListVC(userData: UserDataModel?) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "directToWeatherListVC", sender: userData)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "directToWeatherListVC" {
            let weatherListVC = segue.destination as! WeatherListViewController
            if let userData = sender as? UserDataModel {
                weatherListVC.userData = userData
            }
        }
    }
}
