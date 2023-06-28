//
//  AddWeatherSuccessViewController.swift
//  ACMSC
//
//  Created by Mia Zou on 6/27/23.
//

import UIKit

class AddWeatherSuccessViewController: UIViewController {
    var userData: UserDataModel?
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func buttonTapped(_ sender: Any) {
        if let viewControllers = navigationController?.viewControllers {
            for viewController in viewControllers {
                if let weatherListVC = viewController as? WeatherListViewController {
                    navigationController?.popToViewController(weatherListVC, animated: true)
                    break
                }
            }
        }
    }
}
