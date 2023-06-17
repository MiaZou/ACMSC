//
//  SignInViewController.swift
//  ACMSC
//
//  Created by Mia Zou on 6/8/23.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var actionMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        Task { @MainActor in
            await userSignIn()
        }
    }
    
    func userSignIn() async {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            self.displayErrorMessage("Account login successfully!")
        } catch {
            print(error.localizedDescription)
            self.displayErrorMessage(error.localizedDescription)
            return
        }
        do {
            let uid = try await getCurrentUserUID()
            performSegue(withIdentifier: "directToLoadingVC", sender: uid)
        } catch {
            print(error.localizedDescription)
            self.displayErrorMessage(error.localizedDescription)
            return
        }
        
    }
    
    func getCurrentUserUID() async throws -> String {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "YourDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "User is not authenticated."])
        }
        
        return uid
    }
    
    func displayErrorMessage(_ message: String) {
        actionMessage.text = message
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("sender \(String(describing: sender))")
        if segue.identifier == "directToLoadingVC" {
            let loadingVC = segue.destination as! LoadingViewController
            if let uid = sender as? String {
                loadingVC.uid = uid
            }
        }
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
