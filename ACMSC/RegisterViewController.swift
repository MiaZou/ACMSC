//
//  RegisterViewController.swift
//  ACMSC
//
//  Created by Mia Zou on 6/8/23.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.text = ""
        // Do any additional setup after loading the view.
    }

    @IBAction func registerSubmitButton(_ sender: UIButton) {
//        errorMessage.text = ""
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { firebaseResult, error in
            if let e = error {
                print(e.localizedDescription)
                self.displayErrorMessage(e.localizedDescription)
            } else {
                // Go to our home screen
                print("Account created successfully!")
                self.displayErrorMessage("Account created successfully!")
            }

        }
    }
    
    func displayErrorMessage(_ message: String) {
        errorMessage.text = message
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
