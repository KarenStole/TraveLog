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

            }else{
                let alert = UIAlertController(title: "Fail to register", message: "Your registration have faild", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
                print("ERROR: An error has ocurred while registration: \(error.debugDescription)")
            }
        }
    }
    
}
