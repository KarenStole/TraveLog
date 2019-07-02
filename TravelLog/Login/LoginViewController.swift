//
//  LoginViewController.swift
//  TravelLog
//
//  Created by Jose Soarez on 6/12/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func loginButtomPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){ (user, error) in
            if user != nil{
                self.performSegue(withIdentifier: "goToMain", sender: nil)
                
            }
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    var errorMessage = "Your login have faild"
                    switch errCode {
                    case .invalidEmail:
                        errorMessage = "Invalid password/email"
                    case .userNotFound:
                        errorMessage = "Account not found for the specified user. Please check and try again"
                    case .missingEmail:
                        errorMessage = "Email must not be empty"
                    case .wrongPassword:
                        errorMessage = "Invalid password/email"
                    default:
                        errorMessage = "Your login have faild"
                    }
                    let alert = UIAlertController(title: "Fail to login", message: errorMessage, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                    print("ERROR: An error has ocurred while login: \(error.localizedDescription)")
                }
            }
        }
    }
    

}
