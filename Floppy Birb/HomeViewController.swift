//
//  HomeViewController.swift
//  Floppy Birb
//
//  Created by Tomek on 15/04/2020.
//  Copyright © 2020 ToMMaT. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    
    @IBOutlet weak var themePicker: UIPickerView!
    @IBOutlet weak var diffPicker: UIPickerView!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var highscoreBtn: UIButton!
    
   
    var levels = [] as [String]
    var themes = [] as [String]
    var levelPicked: String = ""
    var themePicked: String = ""
    
    var background = UIImage(named: "earthbg.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themePicker.dataSource = self
        themePicker.delegate = self
        
        diffPicker.dataSource = self
        diffPicker.delegate = self
        diffPicker.selectRow(0, inComponent: 0, animated: true)
        
         levels = ["Easy", "Medium", "Hard"]
         themes = ["Earth", "Moon", "Hell"]
        
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
            let pickedTheme = pickerView.selectedRow(inComponent: 0)
            UserDefaults.standard.set(pickedTheme, forKey: "theme")
            
            if pickedTheme == 0 {
                self.view.backgroundColor = UIColor(patternImage: UIImage(named: "earthbg.png")!)
            } else if pickedTheme == 1 {
                self.view.backgroundColor = UIColor(patternImage: UIImage(named: "spacebg.png")!)
                
            }
            else if pickedTheme == 2 {
                self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hellbg.png")!)
                
            }
            else{
                self.view.backgroundColor = UIColor(patternImage: UIImage(named: "earthbg.png")!)
            }
        }
    }
    
    @IBAction func highscoreTapped(_ sender: Any){
        
        let highscoreViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.highscoreViewController) as? HighscoreViewController
        
        self.view.window?.rootViewController = highscoreViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func playTapped(_ sender: Any){
        
        if(self.label.text == "Choose Difficulty"){
            UserDefaults.standard.set("Medium", forKey: "level")
        }
        
        let gameViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.gameViewController) as? GameViewController
        print(levelPicked)
        self.view.window?.rootViewController = gameViewController
        view.window?.makeKeyAndVisible()
    }
}

