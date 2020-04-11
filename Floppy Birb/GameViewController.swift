//
//  GameViewController.swift
//  Floppy Birb
//
//  Created by mati on 10/04/2020.
//  Copyright © 2020 ToMMaT. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

     override func viewDidLoad() {
            super.viewDidLoad()
        
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
            
        }
     
       override var shouldAutorotate: Bool {
            return false
        }
     
        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return .allButUpsideDown
            } else {
                return .all
            }
        }
     
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Release any cached data, images, etc that aren't in use.
        }
     
        override var prefersStatusBarHidden: Bool {
            return true
        }
    }
