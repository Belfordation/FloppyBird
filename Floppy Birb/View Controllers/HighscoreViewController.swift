//
//  HighscoreViewController.swift
//  Floppy Birb
//
//  Created by Tomek on 25/04/2020.
//  Copyright © 2020 ToMMaT. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HighscoreViewController: UIViewController {
    
    @IBOutlet weak var easyNickname: UILabel!
    @IBOutlet weak var easyScore: UILabel!
    @IBOutlet weak var mediumNickname: UILabel!
    @IBOutlet weak var mediumScore: UILabel!
    @IBOutlet weak var hardNickname: UILabel!
    @IBOutlet weak var hardScore: UILabel!
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference().child("highscores")
        
        ref?.observe(.childAdded, with: {snapshot in
            
            self.easyScore.text = snapshot.value as? String
            
        })
    }
}
