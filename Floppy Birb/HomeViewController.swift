//
//  HomeViewController.swift
//  Floppy Birb
//
//  Created by Tomek on 15/04/2020.
//  Copyright © 2020 ToMMaT. All rights reserved.
//

import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseDatabase
import UIKit

class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var themePicker: UIPickerView!
    @IBOutlet weak var diffPicker: UIPickerView!
    @IBOutlet var themeLabel: UILabel!
    @IBOutlet var playBtn: UIButton!
    @IBOutlet var unlockBtn: UIButton!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var highscoreBtn: UIButton!
    @IBOutlet var scoreLabel: UILabel!
    
    var levels = [] as [String]
    var themes = [] as [String]
    var levelPicked: String = ""
    var themePicked: String = ""
    
    var background = UIImage(named: "earthbg.png")
    
    let user = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    
    var userPoints = Int()
    let spacePrice = 20
    let hellPrice = 40
    
    var pickedTheme = Int()
    
    var isSpaceUnlocked = Bool()
    var isHellUnlocked = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themePicker.dataSource = self
        themePicker.delegate = self
        
        diffPicker.dataSource = self
        diffPicker.delegate = self
        diffPicker.selectRow(0, inComponent: 0, animated: true)
        
         levels = ["Easy", "Medium", "Hard"]
         themes = ["Earth", "Moon", "Hell"]
        
        self.unlockBtn.isHidden = true
        
        let doc = db.collection("users").whereField("id", isEqualTo: Auth.auth().currentUser?.uid)
        
        doc.getDocuments{ (snapshot, error) in
            if error != nil{
                print(error)
            } else {
                for document in (snapshot?.documents)! {
                    let userScore = document.data()["points"] as! String
                    self.userPoints = Int(userScore)!
                    
                    self.scoreLabel.text = "Points: \(self.userPoints)"
                    
                    self.isSpaceUnlocked = document.data()["spaceThemeUnlocked"] as! Bool
                    self.isHellUnlocked = document.data()["hellThemeUnlocked"] as! Bool
                }
            }
        }
        
        self.view.backgroundColor = UIColor(patternImage: background!)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if diffPicker == pickerView {
            levelPicked = levels[row]
            return levels[row]
            
        }
        if themePicker == pickerView {
            themePicked = themes[row]
            return themes[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if diffPicker == pickerView {
            return levels.count
        }
        if themePicker == pickerView {
            return themes.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if diffPicker == pickerView {
            self.levelPicked = levels[row]
            UserDefaults.standard.set(levelPicked, forKey: "level")
        }
        
        if themePicker == pickerView {
            pickedTheme = pickerView.selectedRow(inComponent: 0)
            UserDefaults.standard.set(pickedTheme, forKey: "theme")
            
            if pickedTheme == 0 {
                self.view.backgroundColor = UIColor(patternImage: UIImage(named: "earthbg.png")!)
                self.playBtn.isHidden = false
                self.unlockBtn.isHidden = true
                self.levelLabel.textColor = UIColor.black
                self.themeLabel.textColor = UIColor.black
                self.scoreLabel.textColor = UIColor.black
                self.playBtn.setTitleColor(UIColor.black, for: .normal)
                self.highscoreBtn.setTitleColor(UIColor.black, for: .normal)
                themePicker.backgroundColor = #colorLiteral(red: 0.3419323945, green: 0.3670137947, blue: 0.9804734591, alpha: 0.2112676056)
                diffPicker.backgroundColor = #colorLiteral(red: 0.3419323945, green: 0.3670137947, blue: 0.9804734591, alpha: 0.2112676056)
                
            } else if pickedTheme == 1 {
                self.view.backgroundColor = UIColor(patternImage: UIImage(named: "spacebg.png")!)
                if(!isSpaceUnlocked){
                    self.playBtn.isHidden = true
                    self.unlockBtn.isHidden = false
                } else {
                    self.playBtn.isHidden = false
                    self.unlockBtn.isHidden = true
                }
                self.unlockBtn.setTitle("Unlock for: \(spacePrice)", for: .normal)
                self.levelLabel.textColor = UIColor.white
                self.themeLabel.textColor = UIColor.white
                self.scoreLabel.textColor = UIColor.white
                self.playBtn.setTitleColor(UIColor.white, for: .normal)
                self.unlockBtn.setTitleColor(UIColor.white, for: .normal)
                self.highscoreBtn.setTitleColor(UIColor.white, for: .normal)
                themePicker.backgroundColor = #colorLiteral(red: 0.3419323945, green: 0.3670137947, blue: 0.9804734591, alpha: 0.2112676056)
                diffPicker.backgroundColor = #colorLiteral(red: 0.3419323945, green: 0.3670137947, blue: 0.9804734591, alpha: 0.2112676056)
                
                
            }
            else if pickedTheme == 2 {
                self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hellbg.png")!)
                if(!isHellUnlocked){
                    self.playBtn.isHidden = true
                    self.unlockBtn.isHidden = false
                } else {
                    self.playBtn.isHidden = false
                    self.unlockBtn.isHidden = true
                }
                self.unlockBtn.setTitle("Unlock for: \(hellPrice)", for: .normal)
                self.levelLabel.textColor = UIColor.white
                self.themeLabel.textColor = UIColor.white
                self.scoreLabel.textColor = UIColor.white
                self.playBtn.setTitleColor(UIColor.white, for: .normal)
                self.unlockBtn.setTitleColor(UIColor.white, for: .normal)
                self.highscoreBtn.setTitleColor(UIColor.white, for: .normal)
                themePicker.backgroundColor = #colorLiteral(red: 0.9804734591, green: 0.2338542632, blue: 0.1084753929, alpha: 0.2112676056)
                diffPicker.backgroundColor = #colorLiteral(red: 0.9804734591, green: 0.2338542632, blue: 0.1084753929, alpha: 0.2112676056)
            }
            else{
                self.view.backgroundColor = UIColor(patternImage: UIImage(named: "earthbg.png")!)
                self.playBtn.isHidden = false
                self.unlockBtn.isHidden = true
                self.levelLabel.textColor = UIColor.black
                self.themeLabel.textColor = UIColor.black
                self.scoreLabel.textColor = UIColor.black
                self.playBtn.setTitleColor(UIColor.black, for: .normal)
                self.highscoreBtn.setTitleColor(UIColor.black, for: .normal)
                themePicker.backgroundColor = #colorLiteral(red: 0.3419323945, green: 0.3670137947, blue: 0.9804734591, alpha: 0.2112676056)
                diffPicker.backgroundColor = #colorLiteral(red: 0.3419323945, green: 0.3670137947, blue: 0.9804734591, alpha: 0.2112676056)
            }
        }
    }
    
    @IBAction func unlockTapped(_ sender: Any){
        if(pickedTheme == 1){
            if(userPoints > spacePrice){
               
                    let updatePoints = userPoints - spacePrice
                self.db.collection("users").document((Auth.auth().currentUser?.uid)!).updateData(["spaceThemeUnlocked": true])
                self.db.collection("users").document((Auth.auth().currentUser?.uid)!).updateData(["points": String(updatePoints)])
                
                scoreLabel.text = "Score: \(updatePoints)"
            
                viewDidLoad()
            } else {
                let alert = UIAlertController(title: "Not enough points!", message: "You don't have enough points to unlock this theme!", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        if(pickedTheme == 2){
            if(userPoints > hellPrice){
               
                    let updatePoints = userPoints - hellPrice
                self.db.collection("users").document((Auth.auth().currentUser?.uid)!).updateData(["hellThemeUnlocked": true])
                self.db.collection("users").document((Auth.auth().currentUser?.uid)!).updateData(["points": String(updatePoints)])
                
                scoreLabel.text = "Score: \(updatePoints)"
            
                viewDidLoad()
            } else {
                let alert = UIAlertController(title: "Not enough points!", message: "You don't have enough points to unlock this theme!", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func highscoreTapped(_ sender: Any){
        
        let highscoreViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.highscoreViewController) as? HighscoreViewController
        
        self.view.window?.rootViewController = highscoreViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func playTapped(_ sender: Any){
        
        if(self.levelLabel.text == "Choose Difficulty"){
            UserDefaults.standard.set("Medium", forKey: "level")
        }
        
        let gameViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.gameViewController) as? GameViewController
        print(levelPicked)
        self.view.window?.rootViewController = gameViewController
        view.window?.makeKeyAndVisible()
    }
}


