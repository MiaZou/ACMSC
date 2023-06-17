//
//  RegisterViewController.swift
//  ACMSC
//
//  Created by Mia Zou on 6/8/23.
//

import UIKit
import Firebase
import Foundation

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.text = ""
    }

    @IBAction func registerSubmitButton(_ sender: UIButton) {
        errorMessage.text = ""
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Task {
            await createUserInAuthentication(email: email, password: password)
        }
    }
    
    func createUserInAuthentication(email: String, password: String) async {
        do {
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
            self.displayErrorMessage("Account created successfully!")
        } catch {
            print(error.localizedDescription)
            self.displayErrorMessage(error.localizedDescription)
        }
    }
    
    func displayErrorMessage(_ message: String) {
        self.errorMessage.text = message
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
