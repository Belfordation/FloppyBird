//
//  ViewController.swift
//  Floppy Birb
//
//  Created by mati on 15/04/2020.
//  Copyright © 2020 ToMMaT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
        
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "earthbg.png")!)
        

    setUpElements()
              }
            
            func setUpElements(){
                
                //hide error label
                
                
                
           
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
