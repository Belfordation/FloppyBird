//
//  GameScene.swift
//  Floppy Birb
//
//  Created by mati on 10/04/2020.
//  Copyright © 2020 ToMMaT. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var isGameStarted = Bool(false)
    var isDead = Bool(false)
    let pointSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)

    var score = Int(0)
    var scoreLbl = SKLabelNode()
    var highscoreLbl = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()

    //CREATE THE BIRD ATLAS FOR ANIMATION
    let playerAtlas = SKTextureAtlas(named:"player")
    var playerSprites = Array<Any>()
    var player = SKSpriteNode()
    var repeatActionPlayer = SKAction()
    
    
    
    override func didMove(to view: SKView) {
        createScene()
    }
        
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        }
        
        override func update(_ currentTime: TimeInterval) {
                // Called before each frame is rendered
                if isGameStarted == true{
                    if isDead == false{
                        enumerateChildNodes(withName: "background", using: ({
                            (node, error) in
                            let bg = node as! SKSpriteNode
                            bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                            if bg.position.x <= -bg.size.width {
                                bg.position = CGPoint(x:bg.position.x + bg.size.width * 2, y:bg.position.y)
                            }
                        }))
                    }
                }
        }
    func createScene(){
       self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
       self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
       self.physicsBody?.collisionBitMask = CollisionBitMask.playerCategory
       self.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
       self.physicsBody?.isDynamic = false
       self.physicsBody?.affectedByGravity = false

       self.physicsWorld.contactDelegate = self
       self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        for i in 0..<2 {
                    let background = SKSpriteNode(imageNamed: "bg")
                    background.anchorPoint = CGPoint.init(x: 0, y: 0)
                    background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
                    background.name = "background"
                    background.size = (self.view?.bounds.size)!
                    self.addChild(background)
    
        
        }
        //SET UP THE PLAYER SPRITES FOR ANIMATION
        playerSprites.append(playerAtlas.textureNamed("floppy1"))
        playerSprites.append(playerAtlas.textureNamed("floppy2"))
        playerSprites.append(playerAtlas.textureNamed("floppy3"))
        playerSprites.append(playerAtlas.textureNamed("floppy4"))
        
        self.player = createPlayer()
        self.addChild(player)
                
        //PREPARE TO ANIMATE THE BIRD AND REPEAT THE ANIMATION FOREVER
        let animatePlayer = SKAction.animate(with: self.playerSprites as! [SKTexture], timePerFrame: 0.1)
        self.repeatActionPlayer = SKAction.repeatForever(animatePlayer)
        
        scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)
        
        highscoreLbl = createHighscoreLabel()
        self.addChild(highscoreLbl)
        
        createLogo()
        
        taptoplayLbl = createTaptoplayLabel()
        self.addChild(taptoplayLbl)
    }
    
    }
