//
//  HemisphereViewController.swift
//  ACMSC
//
//  Created by Mia Zou on 6/10/23.
//

import UIKit
import Firebase

class HemisphereViewController: UIViewController {
    
    // hemisphere may have a value of 0 or 1 while 0 = Northern and 1 = Southern.
    var hemisphere = 0
//    var uid: String?
    @IBOutlet weak var northernButton: UIButton!
    @IBOutlet weak var southernButton: UIButton!
    var commercialPopup: PopUp!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        northernButton.addTarget(self, action: #selector(northernButtonClicked), for: .touchUpInside)
        southernButton.addTarget(self, action: #selector(southernButtonClicked), for: .touchUpInside)
        
        northernButton.layer.borderColor = UIColor.systemBlue.cgColor
        northernButton.layer.borderWidth = 2.0
        southernButton.layer.borderColor = UIColor.clear.cgColor
        southernButton.layer.borderWidth = 0.0
    }
    
    @objc private func northernButtonClicked() {
        hemisphere = 0
        northernButton.layer.borderColor = UIColor.systemBlue.cgColor
        northernButton.layer.borderWidth = 2.0
        southernButton.layer.borderColor = UIColor.clear.cgColor
        southernButton.layer.borderWidth = 0.0
    }
    
    @objc private func southernButtonClicked() {
        hemisphere = 1
        northernButton.layer.borderColor = UIColor.clear.cgColor
        northernButton.layer.borderWidth = 0.0
        southernButton.layer.borderColor = UIColor.systemBlue.cgColor
        southernButton.layer.borderWidth = 2.0
    }
    
    @IBAction func clickToSubmit(_ sender: UIButton) {
        Task{
            do {
                try await createUserInDatabase()
            } catch {
                displayPopUp()
            }
        }
    }
    
    func createUserInDatabase() async throws -> Void {
        do {
            let uid = try await getCurrentUserUID()
            if uid == "" {
                displayPopUp()
            } else {
                let url = URL(string: Configuration.apiUrl + "/users/" + uid + "/" + String(hemisphere))!
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
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
        } catch {
            displayPopUp()
        }
    }
    
    func getCurrentUserUID() async throws -> String {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "YourDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "User is not authenticated."])
        }
        
        return uid
    }
    
    func displayPopUp() {
        self.commercialPopup = PopUp(frame: self.view.frame)
        self.commercialPopup.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        self.view.addSubview(commercialPopup)
    }
    
    @objc func closeButtonTapped() {
        self.commercialPopup.removeFromSuperview()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
