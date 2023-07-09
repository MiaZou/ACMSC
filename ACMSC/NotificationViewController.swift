//
//  NotificationViewController.swift
//  ACMSC
//
//  Created by Mia Zou on 7/9/23.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        okButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc func backButtonTapped() {
        print("Button Tapped!")
        performSegue(withIdentifier: "segueToWeatherCalendarFromNotification", sender: nil)
    }

}
