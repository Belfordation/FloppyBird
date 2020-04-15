//
//  SignUpViewController.swift
//  Floppy Birb
//
//  Created by mati on 15/04/2020.
//  Copyright © 2020 ToMMaT. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
          }
        
        func setUpElements(){
            
            //hide error label
            errorLabel.alpha = 0
            
            
       
    }
    
    func validateFields() -> String?{
        
        //check if fields are not empty
        
        if nicknameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        return nil
    }
        // Do any additional setup after loading the view.
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func signUpTapped(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil {
            
            //error occured
            showError(message: error!)
            
        }
        else{
            
            let username = nicknameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //create user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //check for errors
                if err != nil{
                    
                    //error creating account
                    self.showError(message: "Error creating account")
                }
                else{
                    //user created succesfully, store information in database
                    
                    let db = Firestore.firestore()
                    
                    
                    
                    db.collection("users").document((result?.user.uid)!).setData(["username":username, "points":0, "hellThemeUnlocked":false, "spaceThemeUnlocked":false, "highscoreEasy":0, "highscoreMedium":0, "highscoreHard":0]) { (error) in
                        
                        if error != nil {
                            //show error
                            self.showError(message: "Error saving data")
                        }
                    }
                    
                    //transition to home screen
                    self.transitionToHome()
                    
                }
            }
            
            
            
            //transition to menu
        }
        
        
    }
    func showError( message:String){
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    func transitionToHome(){
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        let gameViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.gameViewController) as? GameViewController
        
        view.window?.rootViewController = gameViewController
        view.window?.makeKeyAndVisible()
        
    }
}
