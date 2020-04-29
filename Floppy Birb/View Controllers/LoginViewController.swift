//
//  LoginViewController.swift
//  Floppy Birb
//
//  Created by mati on 15/04/2020.
//  Copyright © 2020 ToMMaT. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        
    }
            
            func setUpElements(){
                
                //hide error label
                errorLabel.alpha = 0
                
                
           
        }

    @IBAction func loginTapped(_ sender: Any) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else{
                
                let gameViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.gameViewController) as? GameViewController
                
                self.view.window?.rootViewController = gameViewController
                self.view.window?.makeKeyAndVisible()
                
            }
        }
        
    }
}
