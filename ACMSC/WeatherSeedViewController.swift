//
//  WeatherSeedViewController.swift
//  ACMSC
//
//  Created by Mia Zou on 6/30/23.
//

import UIKit

class WeatherSeedViewController: UIViewController {
    let userData: UserDataModel? = nil
    
    @IBOutlet weak var weatherSeed: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherSeed.text = userData?.weatherSeed ?? "No Seed Data"
    }
}
