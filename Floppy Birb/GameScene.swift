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
    if isGameStarted == false{
        isGameStarted = true
        player.physicsBody?.affectedByGravity = true
        createPauseBtn()
        
        logoImg.run(SKAction.scale(by: 0.5, duration: 0.3), completion:
            {
                self.logoImg.removeFromParent()
        })
        taptoplayLbl.removeFromParent()
        
        self.player.run(repeatActionPlayer)
        
        let spawn = SKAction.run({
            () in
            self.wallPair = self.createWalls()
            self.addChild(self.wallPair)
        })
        
        let delay = SKAction.wait(forDuration: 1.5)
        let SpawnDelay = SKAction.sequence([spawn, delay])
        let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
        self.run(spawnDelayForever)
        
        let distance = CGFloat(self.frame.width + wallPair.frame.width)
        let movePillars = SKAction.moveBy(x: -distance - 50, y: 0,
                                          duration: TimeInterval(0.008 * distance))
        let removePillars = SKAction.removeFromParent()
        moveAndRemove = SKAction.sequence([movePillars, removePillars])
        
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
    } else {
        
        if isDead == false{
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
        }
    
    }
    
    for touch in touches{
        let location = touch.location(in: self)
        if isDead==true{
            if restartBtn.contains(location){
                if UserDefaults.standard.object(forKey: "highestScore") != nil{
                    let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                    if hscore < Int(scoreLbl.text!)!{
                        UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                    }
                } else {
                    UserDefaults.standard.set(0, forKey: "highestScore")
                }
                restartScene()
            }
        } else {
            if pauseBtn.contains(location){
                if self.isPaused == false{
                    self.isPaused=true
                    pauseBtn.texture = SKTexture(imageNamed: "play")
                } else {
                    self.isPaused = false
                    pauseBtn.texture = SKTexture(imageNamed: "pause")
                }
            }
        }
    }
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
        
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == CollisionBitMask.playerCategory &&
           secondBody.categoryBitMask == CollisionBitMask.pillarCategory ||
            firstBody.categoryBitMask == CollisionBitMask.pillarCategory &&
            secondBody.categoryBitMask == CollisionBitMask.playerCategory ||
            firstBody.categoryBitMask == CollisionBitMask.playerCategory &&
            secondBody.categoryBitMask == CollisionBitMask.groundCategory ||
            firstBody.categoryBitMask == CollisionBitMask.groundCategory &&
            secondBody.categoryBitMask == CollisionBitMask.playerCategory{
            
            enumerateChildNodes(withName: "wallPair", using: ({
                (node,error) in
                node.speed = 0
                self.removeAllActions()
            }))
            
            if isDead == false{
                isDead = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                self.player.removeAllActions()
            }
        } else if firstBody.categoryBitMask == CollisionBitMask.playerCategory &&
                  secondBody.categoryBitMask == CollisionBitMask.flowerCategory{
            run(pointSound)
            score += 1
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
        } else if firstBody.categoryBitMask == CollisionBitMask.flowerCategory &&
            secondBody.categoryBitMask == CollisionBitMask.playerCategory{
            run(pointSound)
            score += 1
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
        }
    }
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        isDead = false
        isGameStarted = false
        score = 0
        createScene()
    }
}
