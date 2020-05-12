import SpriteKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseDatabase


struct CollisionBitMask {
    static let playerCategory:UInt32 = 0x1 << 0
    static let pillarCategory:UInt32 = 0x1 << 1
    static let flowerCategory:UInt32 = 0x1 << 2
    static let groundCategory:UInt32 = 0x1 << 3
}

extension GameScene {
    
    
    
    
    
    func createPlayer() -> SKSpriteNode {
            //1
            let player = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("floppy1"))
            player.size = CGSize(width: 65, height: 65)
            player.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
            //2
            player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
            player.physicsBody?.linearDamping = 1.1
            player.physicsBody?.restitution = 0
            //3
            player.physicsBody?.categoryBitMask = CollisionBitMask.playerCategory
            player.physicsBody?.collisionBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
            player.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.flowerCategory | CollisionBitMask.groundCategory
            //4
            player.physicsBody?.affectedByGravity = false
            player.physicsBody?.isDynamic = true
            
            return player
    }

    func createRestartBtn(){
        restartBtn = SKSpriteNode(imageNamed: "restart")
        restartBtn.size = CGSize(width: 100, height: 100)
        restartBtn.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        
        
        
    }
    
    func createPauseBtn(){
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.size = CGSize(width: 40, height: 40)
        pauseBtn.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }
    
    func createRankingBtn(){
        rankingBtn = SKSpriteNode(imageNamed: "pause")
        rankingBtn.size = CGSize(width: 40, height: 40)
        rankingBtn.position = CGPoint(x: self.frame.width - 60, y: 30)
        rankingBtn.zPosition = 6
        self.addChild(rankingBtn)
    }
    
    
    func createScoreLabel() -> SKLabelNode {
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + self.frame.height/2.6)
        scoreLbl.text = "\(score)"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 50
        scoreLbl.fontName = "HelveticaNeue-Bold"
        
        
        
        let scoreBg = SKShapeNode()
        scoreBg.position = CGPoint(x: 0, y: 0)
        scoreBg.path = CGPath(roundedRect: CGRect(x: CGFloat(-50), y: CGFloat(-30), width: CGFloat(100), height: CGFloat(100)), cornerWidth: 50, cornerHeight: 50, transform: nil)
        let scoreBgColor = UIColor(red: CGFloat(0.0/255.0), green: CGFloat(0.0/255.0), blue:
            CGFloat(0.0/255.0), alpha: CGFloat(0.2))
        scoreBg.strokeColor = UIColor.clear
        scoreBg.fillColor = scoreBgColor
        scoreBg.zPosition = -1
        scoreLbl.addChild(scoreBg)
        return scoreLbl
    }
    
    func createHighscoreLabel() -> SKLabelNode{
        let highscoreLbl = SKLabelNode()
        highscoreLbl.position = CGPoint(x: self.frame.width-80, y: self.frame.height-22)
        if let highestScore = UserDefaults.standard.object(forKey: "highestScore"){
            highscoreLbl.text = "Highest Score: \(highestScore)"
        } else {
            highscoreLbl.text = "Highest Score: 0"
        }
        highscoreLbl.zPosition = 5
        highscoreLbl.fontSize = 15
        highscoreLbl.fontName = "Helvetica-Bold"
        return highscoreLbl
    }
    
    func createLogo(){
        logoImg = SKSpriteNode()
        logoImg = SKSpriteNode(imageNamed: "logo")
        logoImg.size = CGSize(width: 350, height: 135)
        logoImg.position = (CGPoint(x: self.frame.midX, y: self.frame.midY + 170))
        logoImg.setScale(0.8)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func createTaptoplayLabel() -> SKLabelNode{
        let taptoplayLbl = SKLabelNode()
        taptoplayLbl.position = (CGPoint(x: self.frame.midX, y: self.frame.midY-130	))
        taptoplayLbl.text = "Tap anywhere to play"
        taptoplayLbl.fontColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
        taptoplayLbl.zPosition = 5
        taptoplayLbl.fontSize = 35
        taptoplayLbl.fontName = "HelveticaNeue"
        return taptoplayLbl
    }
    
    func createWalls() -> SKNode{
        let pointNode = SKSpriteNode(imageNamed: "file")
        pointNode.size = CGSize(width: 40, height: 40)
        pointNode.position = CGPoint(x: self.frame.width+50, y: self.frame.height/2)
        pointNode.physicsBody = SKPhysicsBody(rectangleOf: pointNode.size)
        pointNode.physicsBody?.affectedByGravity = false
        pointNode.physicsBody?.isDynamic = false
        pointNode.physicsBody?.categoryBitMask = CollisionBitMask.flowerCategory
        pointNode.physicsBody?.collisionBitMask = 0
        pointNode.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        pointNode.color = SKColor.blue
        
        wallPair = SKNode()
        wallPair.name = "wallPair"
            
        let topWall = SKSpriteNode(imageNamed: "pillar")
        let btmWall = SKSpriteNode(imageNamed: "pillar")
        
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 420)
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 420)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        topWall.physicsBody?.collisionBitMask = CollisionBitMask.playerCategory
        topWall.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        btmWall.physicsBody?.collisionBitMask = CollisionBitMask.playerCategory
        btmWall.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        
        topWall.zRotation = CGFloat.pi
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        
        let randomPosition = random(min: -100, max: 100)
        wallPair.position.y = wallPair.position.y + randomPosition
        wallPair.addChild(pointNode)
        
        wallPair.run(moveAndRemove)
        
        return wallPair
        
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max-min) + min
    }
}

