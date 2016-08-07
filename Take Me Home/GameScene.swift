//
//  GameScene.swift
//  Take Me Home
//
//  Created by MakeSchool on 7/11/16.
//  Copyright (c) 2016 Jorge Avelar. All rights reserved.
//

import SpriteKit
import UIKit


// MARK: - GameState Enum
//Tracking enum for game state
enum GameState {
    case Ready, Playing, GameOver
}



// MARK: - Physics Categories

struct PhysicsCategory{
    static let None:         UInt32 = 0
    static let Player:       UInt32 = 0b1
    static let Asteroid:     UInt32 = 0b10
    static let HealthUp:     UInt32 = 0b100
    static let ShootPowerUp: UInt32 = 0b1000
    static let bullets:      UInt32 = 0b10000
}



class GameScene: SKScene, SKPhysicsContactDelegate {
    //Game management
    
    // MARK: - Properties
    
    var state: GameState = .Ready
    
    //spriteNodes
    var asteroid = SKSpriteNode()
    var ufo = SKSpriteNode()
    var healthUp = SKSpriteNode()
    var healthUp2 = SKSpriteNode()
    var shootPowerUp = SKSpriteNode()
    var bullets  = SKSpriteNode()
    var bulletsImage = SKSpriteNode()
    var life = SKSpriteNode()
    var arrow = SKSpriteNode()
    var arrow2 = SKSpriteNode()
    var circle = SKSpriteNode()
    var instructions = SKSpriteNode()
    
    var viewController: GameViewController!
    
    //emmiters
    var explosion = SKEmitterNode()
    var boom = SKEmitterNode()
    var smoke = SKEmitterNode()
    var starsBackground = SKEmitterNode()
    
    //labels
    var scoreLabel = SKLabelNode(fontNamed: "Counter-Strike")
    var highScoreLabel = SKLabelNode(fontNamed: "Counter-Strike")
    var startLabel1 = SKLabelNode(fontNamed: "Counter-Strike")
    var startLabel2 = SKLabelNode(fontNamed: "Counter-Strike")
    var startLabel3 = SKLabelNode(fontNamed: "Counter-Strike")
    var startLabel4 = SKLabelNode(fontNamed: "Counter-Strike")
    var bulletCountLabel = SKLabelNode(fontNamed: "Counter-Strike")
    var gameOverLabel = SKLabelNode(fontNamed: "Counter-Strike")
    var tapLabel = SKLabelNode(fontNamed: "Counter-Strike")
    
    var healthUpSound = SKAudioNode()
    var asteroidSound = SKAudioNode()
    var gameOverDeath = SKAudioNode()
    var shootPowerUpSound  = SKAudioNode()
    
    //MSButtonNode
    var restartButton = MSButtonNode(imageNamed: "restartButton")
    var controlButton = MSButtonNode(imageNamed: "controlButton")
    var homeButton = MSButtonNode(imageNamed: "homeButton")
    
    //nodes
    var nodeTouched = SKNode()
    var currentNodeTouched = SKNode()
    
    var isFingerOnButton = false
    var canShootPowerUp = false
    
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
   
    var lifeBar: CGFloat = 1.0 {
        didSet {
            //Cap Life
            if lifeBar > 1.0 { lifeBar = 1.0 }
            
            //Cap Life
            if lifeBar < 0 { lifeBar = 0 }
            
            //Life between 0.0 -> 1.0 aka 100%
            life.xScale = lifeBar
        }
    }
    
    var bulletCount: Int = 20 {
        didSet {
            let yellowColor = makeColor(234, green: 202, blue: 87, alpha: 1)
            bulletCountLabel.fontColor = yellowColor
            
            bulletCountLabel.text = String(bulletCount)
        }
    }
    
    func makeColor(red: Int, green: Int, blue: Int, alpha: CGFloat) -> SKColor {
        return SKColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }
    
    
    // MARK: - Utility Methods
    
    // The Asteroid
    func createAsteroids() {
        
        //Calling the asteroid Sprite
        asteroid = SKSpriteNode(imageNamed: "asteroid")
        
        // asteroid scale
        asteroid.xScale = 0.1
        asteroid.yScale = 0.1
        asteroid.zPosition = 3
        
        // the positon where asteroids will spawn
        let randomPosition = CGFloat(arc4random() % 15 * 20 + 100)
        //print("Asteroid Position is " + String(randomPosition))
        asteroid.position.x = view!.frame.size.width/2
        asteroid.position.y = CGFloat(randomPosition) - 230
        

        
        // asteroid physics
        asteroid.physicsBody = SKPhysicsBody(circleOfRadius: asteroid.size.width/2)
        asteroid.physicsBody!.dynamic = true
        asteroid.physicsBody!.affectedByGravity = false
        
        // the asteroids may only make contact with the player
        asteroid.physicsBody!.categoryBitMask    = PhysicsCategory.Asteroid
        asteroid.physicsBody!.contactTestBitMask = PhysicsCategory.Player
        asteroid.physicsBody!.collisionBitMask   = PhysicsCategory.None
        
        
        // asteroid color
        asteroid.colorBlendFactor = CGFloat(arc4random_uniform(60) + 20) / 100
        asteroid.color = UIColor(hue: 0.7, saturation: 0.5, brightness: 1, alpha: 1)
        
        
        // *** Random duration the asteroid will move across the screen
        if score >= 60 {
            let randomTime: UInt32 = 40
            let minTime = 100.0
            let randomDuration = (Double(arc4random_uniform(randomTime)) + minTime) / 100
            let moveAction = SKAction.moveToX(-300, duration: randomDuration)
            let removeAction = SKAction.removeFromParent()
            let blockAction = SKAction.sequence([moveAction, removeAction])
            asteroid.runAction(blockAction)
        } else if score >= 15 {
            let randomTime: UInt32 = 80
            let minTime = 211.0
            let randomDuration = (Double(arc4random_uniform(randomTime)) + minTime) / 100
            let moveAction = SKAction.moveToX(-300, duration: randomDuration)
            let removeAction = SKAction.removeFromParent()
            let blockAction = SKAction.sequence([moveAction, removeAction])
            asteroid.runAction(blockAction)
        } else {
            let randomTime: UInt32 = 140
            let minTime = 311.0
            let randomDuration = (Double(arc4random_uniform(randomTime)) + minTime) / 100
            let moveAction = SKAction.moveToX(-300, duration: randomDuration)
            let removeAction = SKAction.removeFromParent()
            let blockAction = SKAction.sequence([moveAction, removeAction])
            asteroid.runAction(blockAction)
        }
        
        
        // *** Random rotation
        let randomRotation = (Double(arc4random_uniform(1256)) - 628) / 100
        //print("Rotation is " + String(randomRotation))
        let rotationRandomDuration = Double(arc4random_uniform(2) + 2)
        let action = SKAction.rotateByAngle(CGFloat(randomRotation), duration: rotationRandomDuration)
        asteroid.runAction(SKAction.repeatActionForever(action))
        
        addChild(asteroid)
        //print("Asteroid")
    }
    
    //this will be the ufo the user will have to move up and down
    func setupPlayer() {
        ufo = SKSpriteNode(imageNamed: "ufoSprite")
        ufo.name = "ufoName"
        ufo.xScale = 0.13
        ufo.yScale = 0.13
        ufo.zPosition = 5
        ufo.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ufo.position.x = view!.frame.size.width / 10 + -250
        print (ufo.position.x)
        ufo.position.y = 0
        
        ufo.physicsBody = SKPhysicsBody(circleOfRadius: ufo.size.height/2)
        
        ufo.physicsBody!.affectedByGravity = false
        // The player will collide with the nothing, and make contact with asteroid and healthUP
        ufo.physicsBody!.categoryBitMask     = PhysicsCategory.Player
        ufo.physicsBody!.collisionBitMask    = PhysicsCategory.None
        ufo.physicsBody!.contactTestBitMask  = PhysicsCategory.Asteroid | PhysicsCategory.HealthUp | PhysicsCategory.ShootPowerUp
        addChild(ufo)
    }
    
    //this will setUP the healthUps for the game
    func makeHealthUps() {
        
        //calling the healthUp Sprite
        healthUp = SKSpriteNode(imageNamed: "lifeUp")
        healthUp.xScale = 0.025
        healthUp.yScale = 0.025
        healthUp.zPosition = 2
        healthUp.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        healthUp.alpha = 0.9
        
        // helathUps position
        healthUp.position.x = view!.frame.size.width/2
        let randomY = CGFloat(arc4random() % 15 * 20 + 100)
        healthUp.position.y = CGFloat(randomY) - 220
        
        healthUp2 = SKSpriteNode(imageNamed: "lifeUp2")
        healthUp2.xScale = 0.6
        healthUp2.yScale = 0.6
        healthUp2.zPosition = 3
        healthUp2.position.y = -20
        healthUp.addChild(healthUp2)
        
        
        // healthUps Physics
        healthUp.physicsBody = SKPhysicsBody(circleOfRadius:(healthUp.size.width/2))
        healthUp.physicsBody!.affectedByGravity = false
        healthUp.physicsBody!.dynamic = false
        
        // healthUps will collide with nothing and contact only with player
        healthUp.physicsBody!.categoryBitMask   = PhysicsCategory.HealthUp
        healthUp.physicsBody!.collisionBitMask  = PhysicsCategory.None
        healthUp.physicsBody!.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.bullets
        
        
        // duration the healthUps will move across the screen
        let moveAction = SKAction.moveToX(-300, duration: 4)
        let removeAction = SKAction.removeFromParent()
        let blockAction = SKAction.sequence([moveAction, removeAction])
        healthUp.runAction(blockAction)
        
        addChild(healthUp)
        //print("Health Up")
    }
    
    func makeShootPowerUps() {
        
        //calling the healthUp Sprite
        shootPowerUp = SKSpriteNode(imageNamed: "spaceGun")
        shootPowerUp.xScale = 0.2
        shootPowerUp.yScale = 0.2
        shootPowerUp.zPosition = 2
        shootPowerUp.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shootPowerUp.alpha = 0.9
        
        // helathUps position
        shootPowerUp.position.x = view!.frame.size.width/2
        let randomY = CGFloat(arc4random() % 15 * 20 + 100)
        shootPowerUp.position.y = CGFloat(randomY) - 220
        
        // healthUps Physics
        shootPowerUp.physicsBody = SKPhysicsBody(circleOfRadius:(shootPowerUp.size.width/2))
        shootPowerUp.physicsBody!.affectedByGravity = false
        shootPowerUp.physicsBody!.dynamic = false
        
        // healthUps will collide with nothing and contact only with player
        shootPowerUp.physicsBody!.categoryBitMask   = PhysicsCategory.ShootPowerUp
        shootPowerUp.physicsBody!.collisionBitMask  = PhysicsCategory.None
        shootPowerUp.physicsBody!.contactTestBitMask = PhysicsCategory.Player
        
        
        // duration the healthUps will move across the screen
        let moveAction = SKAction.moveToX(-300, duration: 3)
        let removeAction = SKAction.removeFromParent()
        let blockAction = SKAction.sequence([moveAction, removeAction])
        shootPowerUp.runAction(blockAction)
        
        addChild(shootPowerUp)
    }
    
    func setUpBullets() {
        let bullet = SKSpriteNode(imageNamed: "rocket")
        bullet.xScale = 0.1
        bullet.yScale = 0.1
        bullet.zPosition = 1
        let position = ufo.position
        bullet.position = position
        
        // bullets Physics
        bullet.physicsBody = SKPhysicsBody(rectangleOfSize:(bullet.size))
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.dynamic = true
        
        // bullets will collide with nothing and contact only with asteroid
        bullet.physicsBody!.categoryBitMask   = PhysicsCategory.bullets
        bullet.physicsBody!.collisionBitMask  = PhysicsCategory.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategory.Asteroid | PhysicsCategory.HealthUp
        
        let action = SKAction.moveToX(self.size.width + 30, duration: 2)
        let shotSoundEffect = SKAction.playSoundFileNamed("Machine Gun Shooting.mp3", waitForCompletion: false)
        let actionDone = SKAction.removeFromParent()
        bullet.runAction(SKAction.sequence([shotSoundEffect, action, actionDone]))
        addChild(bullet)
        
        let pushback = SKAction.moveToX(view!.frame.size.width / 10 + -260, duration: 0.1)
        let goBack = SKAction.moveToX(view!.frame.size.width / 10 + -250, duration: 0.1)
        let seq = SKAction.sequence([pushback, goBack])
        ufo.runAction(seq)
    }
    
    func setUpBulletCount() {
        let position = life.position.y
        bulletCountLabel.position = CGPoint(x: -8, y: position - 30)
        bulletCountLabel.fontSize = 36
        bulletCountLabel.text  = ("20")
        bulletCountLabel.zPosition = 5
        bulletCountLabel.removeFromParent()
        
        let fadeIn = SKAction.fadeInWithDuration(0.2)
        bulletCountLabel.runAction(fadeIn)
        addChild(bulletCountLabel)
    }
    
    func setUpBulletImage() {
        bulletsImage = SKSpriteNode (imageNamed: "missile")
        bulletsImage.xScale = 0.035
        bulletsImage.yScale = 0.035
        bulletsImage.zPosition = 5
        bulletsImage.anchorPoint = CGPoint(x: 0,y: 0)
        let YPosition = bulletCountLabel.position.y
        let XPosition = bulletCountLabel.position.x
        bulletsImage.position.y = YPosition - 2
        bulletsImage.position.x = XPosition + 30
        
        let fadeIn = SKAction.fadeInWithDuration(0.2)
        bulletsImage.runAction(fadeIn)
        addChild(bulletsImage)
    }
    
    func setUpShootInstructions() {
        tapLabel.text = "Tap"
        tapLabel.fontSize = 24
        tapLabel.position = CGPoint(x: -130, y: -80)
        addChild(tapLabel)
        
        tapLabel.alpha = 0
        let fadeIn = SKAction.fadeInWithDuration(0.5)
        let wait = SKAction.waitForDuration(0.2)
        let fadeOut = SKAction.fadeOutWithDuration(0.5)
        let seq = SKAction.sequence([fadeIn, wait, fadeOut])
        let forever = SKAction.repeatActionForever(seq)
        tapLabel.runAction(forever, withKey: "actionC")
    }
    
    // this is the lifeBar in the game
    func setUpLifeBar() {
        let lifeBar = SKSpriteNode(imageNamed: "life_bg")
        lifeBar.position = CGPoint(x: 0, y: 125)
        lifeBar.zPosition = 10
        lifeBar.yScale = 0.7
        addChild(lifeBar)
    }
    
    // this is the life inside the lifeBar
    func setUpLife(){
        life = SKSpriteNode(imageNamed: "life")
        life.position = CGPoint(x: -68.5, y: 116)
        life.anchorPoint = CGPoint(x: 0, y: 0)
        life.zPosition = 11
        life.yScale = 0.7
        life.xScale = 1.01
        addChild(life)
    }

   
    //this will create the asteroids action spawning from the right side of the screen
    func startMakingAsteroids() {
        
        // Make Asteroids
        let createAsteroids = SKAction.runBlock {
            self.createAsteroids()
        }
        
        
        // delay between every asteroid
        if score >= 70 {
            let asteroidDelay = SKAction.waitForDuration(0.05)
            let asteroidSequence = SKAction.sequence([asteroidDelay, createAsteroids])
            let repeatAsteroids = SKAction.repeatActionForever(asteroidSequence)
            runAction(repeatAsteroids)
        } else if score >= 40 {
            let asteroidDelay = SKAction.waitForDuration(0.15)
            let asteroidSequence = SKAction.sequence([asteroidDelay, createAsteroids])
            let repeatAsteroids = SKAction.repeatActionForever(asteroidSequence)
            runAction(repeatAsteroids)
        } else {
            let asteroidDelay = SKAction.waitForDuration(0.30)
            let asteroidSequence = SKAction.sequence([asteroidDelay, createAsteroids])
            let repeatAsteroids = SKAction.repeatActionForever(asteroidSequence)
            runAction(repeatAsteroids)
        }
    }
    
    //this will create the powerUps action spawning from the right side of the screen
    func startMakingHealthUps() {
        
        // Make healthUps
        let createHealthUps = SKAction.runBlock {
            self.makeHealthUps()
        }
        
        // delay between healthUps
        let healthUpsDelay = SKAction.waitForDuration(2)
        let healthUpsSequence = SKAction.sequence([healthUpsDelay, createHealthUps])
        let repeatHealthUps = SKAction.repeatActionForever(healthUpsSequence)
        
        self.runAction(repeatHealthUps, withKey: "actionA")
    }
    
    func startMakingShootPowerUps() {
        
        // Make healthUps
        let createShootPowerUps = SKAction.runBlock {
            self.makeShootPowerUps()
        }
        
        // delay between healthUps
        let randomTime: UInt32 = 5
        let minTime = 2.7
        let randomDuration = (Double(arc4random_uniform(randomTime)) + minTime)
        let shootPowerUpsDelay = SKAction.waitForDuration(randomDuration)
        let shootPowerUpsSequence = SKAction.sequence([shootPowerUpsDelay, createShootPowerUps])
        let repeatShootPowerUps = SKAction.repeatActionForever(shootPowerUpsSequence)
        
        self.runAction(repeatShootPowerUps, withKey: "actionB")
    }
    
    func setUpControlButton() {
        controlButton.name = "buttonName"
        let position = ufo.position.y
        controlButton.position = CGPoint(x: 230, y: position)
        controlButton.zPosition = 5
        controlButton.xScale = 0.5
        controlButton.yScale = 0.5
        addChild(controlButton)
    }
    
    // this will create the background to the game
    func starsBackgroundCreation() {
        starsBackground = SKEmitterNode(fileNamed: "Stars")!
        starsBackground.targetNode = self.scene
        starsBackground.position = CGPoint(x: frame.size.width/2, y: (frame.size.height/2 - 150))
        starsBackground.advanceSimulationTime(30)
        starsBackground.zPosition = -1
        addChild(starsBackground)
    }
    
    func setUpStartLabel1() {
        startLabel1.fontSize = 32
        startLabel1.text = ("Drag the Analog")
        startLabel1.position = CGPoint(x: 0, y: 40)
        startLabel1.zPosition = 10
        addChild(startLabel1)
    }
    
    func setUpStartLablePart2() {
        startLabel2.fontSize = 40
        startLabel2.text  = ("Stick")
        startLabel2.position = CGPoint(x: 0, y: 0)
        startLabel2.zPosition = 10
        addChild(startLabel2)
    }
    
    func setUpStartLabelPart3() {
        startLabel3.fontSize = 32
        startLabel3.text = ("Up or Down")
        startLabel3.position = CGPoint(x: 0, y: -35)
        startLabel3.zPosition = 10
        addChild(startLabel3)
    }
    
    func setUpLabelPart4() {
        startLabel4.fontSize = 32
        startLabel4.text = ("To Begin")
        startLabel4.position = CGPoint(x: 0, y: -75)
        startLabel4.zPosition = 10
        addChild(startLabel4)
    }
    
    func instructionsCircle() {
        circle = SKSpriteNode(imageNamed: "circle")
        circle.position = ufo.position
        circle.xScale = 0.15
        circle.yScale = 0.15
        circle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        circle.zPosition = 4
        
        let action = SKAction.rotateByAngle(CGFloat(-6.28), duration: 7)
        circle.runAction(SKAction.repeatActionForever(action))
        
        addChild(circle)
    }
    
    func setUpArrows() {
        arrow = SKSpriteNode(imageNamed: "arrow")
        arrow.position = CGPoint(x: 230, y: 90)
        arrow.xScale = 0.15
        arrow.yScale = 0.15
        arrow.zPosition = 10
        addChild(arrow)
        
        arrow2 = SKSpriteNode(imageNamed: "arrow2")
        arrow2.position = CGPoint(x: 230, y: -90)
        arrow2.xScale = 0.15
        arrow2.yScale = 0.15
        arrow2.zPosition = 10
        addChild(arrow2)
        
        let fade = SKAction.fadeOutWithDuration(0.5)
        let wait = SKAction.waitForDuration(0.2)
        let fadeIn = SKAction.fadeInWithDuration(0.5)
        let seq = SKAction.sequence([fade, wait, fadeIn, wait])
        let forever = SKAction.repeatActionForever(seq)
        arrow.runAction(forever)
        arrow2.runAction(forever)
    }
    
    func fadeAwayInstructions() {
        let fadeAway = SKAction.fadeOutWithDuration(0.5)
        let removeNode = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeAway, removeNode])
        startLabel1.runAction(sequence)
        startLabel2.runAction(sequence)
        startLabel3.runAction(sequence)
        startLabel4.runAction(sequence)
        arrow.runAction(sequence)
        arrow2.runAction(sequence)
        circle.runAction(sequence)
    }
    
    func setUpInstructions() {
        instructions = SKSpriteNode(imageNamed: "instructions")
        instructions.xScale = 0.7
        instructions.yScale = 0.7
        instructions.position.x = 0
        instructions.position.y = -20
        instructions.zPosition = 10
        
        let fadeIn = SKAction.fadeInWithDuration(0.5)
        let wait = SKAction.waitForDuration(2)
        let fadeOut = SKAction.fadeOutWithDuration(0.3)
        let seq = SKAction.sequence([fadeIn, wait, fadeOut])
        instructions.runAction(seq)
        addChild(instructions)

        
    }
    
    func setUpGameOverLabel() {
        let goldColor = makeColor(214, green: 185, blue: 0, alpha: 1)
        
        gameOverLabel.fontSize = 48
        gameOverLabel.text  = ("GAME OVER")
        gameOverLabel.position = CGPoint(x: 0, y: 20)
        gameOverLabel.zPosition = 10
        gameOverLabel.alpha = 0
        gameOverLabel.fontColor = goldColor
        
        let fadeIn = SKAction.fadeInWithDuration(1.5)
        let sequence = SKAction.sequence([fadeIn])
        gameOverLabel.runAction(sequence)
        addChild(gameOverLabel)
    }
    
    func setUpRestartButton() {
        restartButton.name = "restartButton"
        restartButton.position = CGPoint(x: 0, y: -60)
        restartButton.xScale = 0.8
        restartButton.yScale = 0.8
        restartButton.zPosition = 10
        addChild(restartButton)
        restartButton.state = .Active
        restartButton.selectedHandler = {
            print(">>>> restart button handled! <<<<<")

            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!

            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!

            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit

            /* Restart game scene */
            let reveal: SKTransition = SKTransition.fadeWithDuration(1)
            skView.presentScene(scene, transition: reveal)
            
            scene.viewController = self.viewController
            self.state = .Ready
        }
    }
    
    func setUpHomeButton(){
        homeButton.name = "restartButton"
        homeButton.position = CGPoint(x: 0, y: -100)
        homeButton.xScale = 0.8
        homeButton.yScale = 0.8
        homeButton.zPosition = 10
        addChild(homeButton)
        homeButton.state = .Active
        homeButton.selectedHandler = {
            print(">>>> restart button handled! <<<<<")
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = MainScene (fileNamed:"MainScene") as MainScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Restart game scene */
            let reveal: SKTransition = SKTransition.fadeWithDuration(1)
            skView.presentScene(scene, transition: reveal)
        }
    }
    
    func setUpScoreLabel() {
        scoreLabel.position = CGPoint(x: 130, y: 110)
        scoreLabel.fontSize = 48
        scoreLabel.text  = ("0")
        scoreLabel.zPosition = 5
        self.addChild(scoreLabel)
    }
    
    func scoreLabelCount() {
        let delay = SKAction.waitForDuration(1)
        let incrementScore = SKAction.runBlock ({
            self.score = self.score + 1
            self.scoreLabel.text = "\(self.score)"
        })
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([delay,incrementScore])), withKey: "scoreCount")
    }
    
    func setUpHighScoreLabel() {
        highScoreLabel.position = CGPoint(x: 0, y: -15)
        highScoreLabel.fontSize = 36
        highScoreLabel.zPosition = 5
        highScoreLabel.alpha = 0
        
        let fadeIn = SKAction.fadeInWithDuration(1.5)
        let sequence = SKAction.sequence([fadeIn])
        highScoreLabel.runAction(sequence)
        addChild(highScoreLabel)
    }
    
    func playerScoreUpdate() {
        let highScore = NSUserDefaults().integerForKey("highscore")
        if score > highScore {
            NSUserDefaults().setInteger(score, forKey: "highscore")
        }

      highScoreLabel.text = "High Score: " + NSUserDefaults().integerForKey("highscore").description
    }
    

    
    
    // MARK: - Did Move to View!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.physicsWorld.contactDelegate = self
    
        // Start making asteroids
        startMakingAsteroids()
        
        // Setup the ufo object
        setupPlayer()
        
        setUpControlButton()
        
        //Set the healthUps
        startMakingHealthUps()
        startMakingShootPowerUps()
        
        //Setup emitter background
        starsBackgroundCreation()
        
        //Setup Life Bar
        setUpLifeBar()
    
        //setUp the life 
        setUpLife()

        //game directions pt.1
        setUpStartLabel1()
        
        //game directions pt. 2
        setUpStartLablePart2()
        setUpStartLabelPart3()
        setUpLabelPart4()
        setUpArrows()
        instructionsCircle()
        setUpScoreLabel()
    }
    
   
    // this will call and make the SKEmitter for the healthUp poof
    func makeHealthUpPoofAtPoint(point: CGPoint) {
        if let poof = SKEmitterNode(fileNamed: "healthUpPoof") {
            poof.xScale = 0.2
            poof.yScale = 0.2
            addChild(poof)
            poof.position = point
            let wait = SKAction.waitForDuration(2)
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([wait, remove])
            poof.runAction(seq)
        }
    }
    
    //this will call and make the SKEmitter for the asteroid poof
    func makeAsteroidPoofAtPoint(point: CGPoint) {
        if let asteroidPoof = SKEmitterNode(fileNamed: "asteroidPoof") {
            addChild(asteroidPoof)
            asteroidPoof.position = point
            let wait = SKAction.waitForDuration(0.8)
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([wait, remove])
            asteroidPoof.runAction(seq)
        }
    }
    
    func setUpShootPoof(point: CGPoint) {
        if let shootPoof = SKEmitterNode(fileNamed: "") {
            shootPoof.position = point
            addChild(shootPoof)
            let fadeAway = SKAction.fadeOutWithDuration(0.5)
            let wait = SKAction.waitForDuration(0.8)
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([wait, fadeAway, wait, remove])
            shootPoof.runAction(seq)
            
        }
    }
    
    func setUpExplosion(point: CGPoint) {
        if let explosion = SKEmitterNode(fileNamed: "explosion") {
        explosion.position = point
        addChild(explosion)
        let fadeAway = SKAction.fadeOutWithDuration(0.5)
        let wait = SKAction.waitForDuration(0.8)
        let remove = SKAction.removeFromParent()
        let seq = SKAction.sequence([wait, fadeAway, wait, remove])
        explosion.runAction(seq)
        
        }
    }
    
    func setUpSmoke(point: CGPoint) {
        if let smoke = SKEmitterNode(fileNamed: "smoke") {
            smoke.position = ufo.position
            addChild(smoke)
        }
    }
    
    func healthUpSoundEffect() {
        let sound = SKAction.playSoundFileNamed("healthUpSound", waitForCompletion: false)
        healthUpSound.runAction(sound)
        healthUpSound.removeFromParent()
        addChild(healthUpSound)
    }
    
    func aststeroidSoundEffect() {
        let sound = SKAction.playSoundFileNamed("blast (1)", waitForCompletion: false)
        asteroidSound.runAction(sound)
        asteroidSound.removeFromParent()
        addChild(asteroidSound)
    }
    
    func ufoCrashEffect() {
        let color = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 0.3, duration: 0.1)
        let normalColor = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.05)
        let pushback = SKAction.moveToX(view!.frame.size.width / 10 + -255, duration: 0.1)
        let goBack = SKAction.moveToX(view!.frame.size.width / 10 + -240, duration: 0.1)
        let normal = SKAction.moveToX(view!.frame.size.width / 10 + -250, duration: 0.1)
        let seq = SKAction.sequence([pushback, color, goBack, normal, normalColor])
        
        if lifeBar >= 0.01 {
            ufo.runAction(seq)
        } else {
            ufo.runAction(SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.50))
        }

    }
    
    func shootPowerUpSoundEffect () {
        let sound = SKAction.playSoundFileNamed("powerUpNoise", waitForCompletion: false)
        let wait = SKAction.waitForDuration(0.3)
        let sound2 = SKAction.playSoundFileNamed("gunReload", waitForCompletion: false)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([sound, wait, sound2, remove])
        shootPowerUpSound.runAction(sequence)
        addChild(shootPowerUpSound)
        
    }
    
    func bulletAsteroidPoof(point: CGPoint) {
        if let boom = SKEmitterNode(fileNamed: "boom") {
            boom.position = point
            addChild(boom)
            let fadeAway = SKAction.fadeOutWithDuration(0.5)
            let wait = SKAction.waitForDuration(0.5)
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([wait, fadeAway, wait, remove])
            boom.runAction(seq)
            
        }

    }
    func gameOverDeathSoundEffect() {
        let sound = SKAction.playSoundFileNamed("explosion", waitForCompletion: true)
        let remove = SKAction.removeFromParent()
        let sequence  = SKAction.sequence([sound, remove])
        gameOverDeath.runAction(sequence)
        addChild(gameOverDeath)
    }
    
   
    // MARK: - Did Begin Contact
    
    var physicsObjectsToRemove = [SKNode]()
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if state == .Ready {return}
        
        if state == .GameOver {return}
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        // contact between asteroid and player
        if collision == PhysicsCategory.Asteroid | PhysicsCategory.Player {
            //print("Player Hit Asteroid")
            
            if contact.bodyA.node!.name == "asteroid" {
                // decrease health
                lifeBar -= 0.3
                ufoCrashEffect()
                aststeroidSoundEffect()
                makeAsteroidPoofAtPoint(contact.bodyA.node!.position)
                physicsObjectsToRemove.append(contact.bodyA.node!)
            } else {
                // decrease health
                lifeBar -= 0.3
                ufoCrashEffect()
                aststeroidSoundEffect()
                makeAsteroidPoofAtPoint(contact.bodyB.node!.position)
                physicsObjectsToRemove.append(contact.bodyB.node!)
            }

            
           // contact between player and healthUp
        } else if collision == PhysicsCategory.HealthUp | PhysicsCategory.Player {
            //print("Player Hit HealthUp")

            if contact.bodyA.node!.name == "healthUp" {
                /* Increment Health */
                lifeBar += 0.1
                healthUpSoundEffect()
                makeHealthUpPoofAtPoint(contact.bodyA.node!.position)
                physicsObjectsToRemove.append(contact.bodyA.node!)
            } else {
                /* Increment Health */
                lifeBar += 0.1
                healthUpSoundEffect()
                makeHealthUpPoofAtPoint(contact.bodyB.node!.position)
                physicsObjectsToRemove.append(contact.bodyB.node!)
            }
            
            // contact between player and shoot power up
        } else if collision == PhysicsCategory.ShootPowerUp | PhysicsCategory.Player {
            
            if contact.bodyA.node!.name == "shootPowerUp" {
                shootPowerUpSoundEffect()
                setUpBulletCount()
                setUpBulletImage()
                setUpShootInstructions()
                bulletCount = 20
                physicsObjectsToRemove.append(contact.bodyA.node!)
                canShootPowerUp = true
                
                if let action = self.actionForKey("actionB") {
                    action.speed = 0
                }
            } else {
                shootPowerUpSoundEffect()
                setUpBulletCount()
                setUpBulletImage()
                setUpShootInstructions()
                bulletCount = 20
                physicsObjectsToRemove.append(contact.bodyB.node!)
                canShootPowerUp = true
                
                if let action = self.actionForKey("actionB") {
                    action.speed = 0
                }
            }
            
        } else if collision == PhysicsCategory.bullets | PhysicsCategory.Asteroid {
            print("Bullet hit Asteroid")
            if contact.bodyA.node!.name == "bullets" {
                physicsObjectsToRemove.append(contact.bodyA.node!)
                physicsObjectsToRemove.append(contact.bodyB.node!)
                aststeroidSoundEffect()
                bulletAsteroidPoof(contact.bodyA.node!.position)
            } else {
                physicsObjectsToRemove.append(contact.bodyA.node!)
                physicsObjectsToRemove.append(contact.bodyB.node!)
                aststeroidSoundEffect()
                bulletAsteroidPoof(contact.bodyB.node!.position)
            }
            
        } else if collision == PhysicsCategory.bullets | PhysicsCategory.HealthUp {
            if contact.bodyA.node!.name == "bullets" {
                physicsObjectsToRemove.append(contact.bodyA.node!)
                physicsObjectsToRemove.append(contact.bodyB.node!)
                aststeroidSoundEffect()
                bulletAsteroidPoof(contact.bodyA.node!.position)
            } else {
                physicsObjectsToRemove.append(contact.bodyA.node!)
                physicsObjectsToRemove.append(contact.bodyB.node!)
                aststeroidSoundEffect()
                bulletAsteroidPoof(contact.bodyB.node!.position)
            }
            // no contact
        } else if collision == PhysicsCategory.Player | PhysicsCategory.None {
            //print("*Player hit nothing*")
            
        }
    }
    
    //remove node after making contact
    override func didSimulatePhysics() {
        for node in physicsObjectsToRemove {
            node.removeFromParent()
        }
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        // Game not ready to play
        if state == .GameOver {
            return
        }
        
        // Game begins on first touch
        if state == .Ready {
            state = .Playing
            fadeAwayInstructions()
            scoreLabelCount()
            setUpInstructions()
        }
        
        //when touching the screen
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = nodeAtPoint(location)
            
            if node.name == "buttonName" && location.x > 0{
                print("touched control button")
                isFingerOnButton = true
                controlButton.alpha = 0.5
            }
            
            if canShootPowerUp {
                if location.x < 0 {
                    setUpBullets()
                    bulletCount -= 1
                    
                    let fadeOut = SKAction.fadeOutWithDuration(0.5)
                    tapLabel.runAction(fadeOut)
                    tapLabel.removeFromParent()
                    tapLabel.removeActionForKey("actionC")
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if state == .GameOver {return}
        
        //if touching ufo, it will be able to move up and down
        if isFingerOnButton {
            
            //update the position of the paddle depending on how the player moves their finger.
            for touch in touches{
                let location = touch.locationInNode(self)
                let previousLocation = touch.previousLocationInNode(self)
            
                if location.x > 0 {
                    //Take the current position and add the difference between the new and the previous touch locations.
                    var ufoY = ufo.position.y + (location.y - previousLocation.y)
                    var buttonY = controlButton.position.y + (location.y - previousLocation.y)
                    //Before repositioning the paddle, limit the position so that the paddle will not go off the screen to the left or right
                    ufoY = max(ufoY, ufo.size.height/2)
                    ufoY = min(ufoY, size.width - ufo.size.height/2)
            
                    buttonY = max(buttonY, controlButton.size.height/2)
                    buttonY = min(buttonY, size.width - controlButton.size.height/2)
            
                    //move ufo based on touch location
                    ufoY = location.y
                    ufo.position.y = location.y
            
                    buttonY = location.y
                    controlButton.position.y = location.y
                }
            
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        

        // when no longer touching control button
        for touch in touches{
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
        
            if node.name == "controlButton" {
            isFingerOnButton = false
            print("No longer touching button")
            controlButton.alpha = 1
            }
        }

    }
    
    
    
    func updateLife () {
        
        //Decrease Health
        lifeBar -= 0.0005
    }
    
    func setUpEndBulletCount() {
        if bulletCount == 0{
            canShootPowerUp = false
            if let action = self.actionForKey("actionB") {
                action.speed = 1
            }
            let fade = SKAction.fadeOutWithDuration(0.2)
            bulletCountLabel.runAction(fade)
            bulletsImage.runAction(fade)
        }
    }
    
    
    func gameOver() {
        /* Game over! */
        
        state = .GameOver
        
        ufo.runAction(SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.50))
        
        setUpGameOverLabel()
        gameOverDeathSoundEffect()
        
        self.removeActionForKey("actionA")
        self.removeActionForKey("actionB")
        self.removeActionForKey("scoreCount")
        
        let fadeOut = SKAction.fadeOutWithDuration(0.5)
        tapLabel.runAction(fadeOut)
        tapLabel.removeFromParent()
        tapLabel.removeActionForKey("actionC")
        
        setUpExplosion(ufo.position)
        
        setUpSmoke(ufo.position)
        
        canShootPowerUp = false
    
        setUpRestartButton()
        setUpHomeButton()
        
        playerScoreUpdate()
        
        setUpHighScoreLabel()
        
        viewController.loadAd()
        
        let fadeAway = SKAction.fadeOutWithDuration(1)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeAway, remove])
        controlButton.runAction(sequence)
        
    }
    

   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    
        if state != .Playing { return }
        
        // decreases life little by little
        updateLife()
        setUpEndBulletCount()
        
        /* Has the player ran out of health? */
        if lifeBar == 0 {
            gameOver()
        }
            
    }
}
