//
//  HighscoreViewController.swift
//  Floppy Birb
//
//  Created by Tomek on 25/04/2020.
//  Copyright © 2020 ToMMaT. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseDatabase

class HighscoreViewController: UIViewController {
    
    
    @IBOutlet weak var easyScore: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var mediumScore: UILabel!
   
    @IBOutlet weak var hardScore: UILabel!
    
    let user = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doc = db.collection("users").whereField("id", isEqualTo: Auth.auth().currentUser?.uid)
        
        doc.getDocuments{ (snapshot, error) in
            if error != nil{
                print(error)
            } else {
                for document in (snapshot?.documents)! {
                    let easyHighscore = document.data()["highscoreEasy"] as! Int
                    let mediumHighscore = document.data()["highscoreMedium"] as! Int
                    let hardHighscore = document.data()["highscoreHard"] as! Int
                    let nicknameDB = document.data()["username"] as! String
                    
                    self.easyScore.text = String(easyHighscore)
                    self.mediumScore.text = String(mediumHighscore)
                    self.hardScore.text = String(hardHighscore)
                    self.nickname.text = String(nicknameDB)+"'s Scores:"
                }
            }
        }
        

    }
}
