//
//  RegisterViewController.swift
//  TravelLog
//
//  Created by Jose Soarez on 6/12/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButtomPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){ (user, error) in
            if user != nil{
                let alert = UIAlertController(title: "Succesfull register", message: "Welcome to TravelLog", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
                self.performSegue(withIdentifier: "goToMain", sender: nil)

            }
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    var errorMessage = "Your registre have faild"
                    switch errCode {
                    case .invalidEmail:
                        errorMessage = "Invalid email"
                    case .emailAlreadyInUse:
                        errorMessage = "The email is already in use with another account"
                    case .missingEmail:
                        errorMessage = "Email must not be empty"
                    case .weakPassword:
                        errorMessage = "Your password is too weak. The password must be 6 characters long or more."
                    default:
                        errorMessage = "Your registre have faild. Please try again"
                    }
                    let alert = UIAlertController(title: "Fail to register", message: errorMessage, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                    print("ERROR: An error has ocurred while registre: \(error.localizedDescription)")
                }
            }
        }
    }
    
}
