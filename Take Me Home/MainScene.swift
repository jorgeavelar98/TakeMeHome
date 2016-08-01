//
//  Menu.swift
//  Take Me Home
//
//  Created by MakeSchool on 7/11/16.
//  Copyright © 2016 Jorge Avelar. All rights reserved.
//
import SpriteKit
import UIKit

class MainScene: SKScene {
    var titleLabel = SKLabelNode()
    var ufo = SKSpriteNode()
    var volume = SKSpriteNode()
    var volume2 = SKSpriteNode()
    var mainBackground = SKEmitterNode()
    
    /* UI Connections */
    var playButton: MSButtonNode!
    var insaneModeButton: MSButtonNode!
    
    //nodes
    var nodeTouched = SKNode()
    var currentNodeTouched = SKNode()
    
    var isFingerOnVolume = false
    var isFingerOnVolume2 = false

    
    
    
    func makeColor(red: Int, green: Int, blue: Int, alpha: CGFloat) -> SKColor {
        return SKColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }

    func setUpTitleLabel(){
        let goldColor = makeColor(214, green: 185, blue: 0, alpha: 1)
        
        titleLabel.fontName = "Counter-Strike"
        titleLabel.fontSize = 48
        titleLabel.text = "Take Me Home"
        titleLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 100)
        titleLabel.zPosition = 5
        titleLabel.fontColor = goldColor
        addChild(titleLabel)
    }

    func setUpUfo() {
        ufo = SKSpriteNode(imageNamed: "ufoSprite")
        ufo.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2 + 30)
        ufo.xScale = 0.4
        ufo.yScale = 0.4
        
        let rotate = SKAction .rotateByAngle(0.5, duration: 1)
        ufo.runAction(rotate)
        addChild(ufo)
    }
    
    func setUpMainBackground() {
        mainBackground = SKEmitterNode(fileNamed: "mainBackground")!
        mainBackground.targetNode = self.scene
        mainBackground.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        mainBackground.advanceSimulationTime(30)
        mainBackground.zPosition = -1
        addChild(mainBackground)

    }
    
    func setUpVolume() {
        volume = SKSpriteNode(imageNamed: "volume")
        volume.name = "volume"
        volume.position = CGPoint(x: 500, y: 45)
        volume.xScale = 0.07
        volume.yScale = 0.07
        volume.zPosition = 10
        addChild(volume)
    }
    
    func setUpVolume2() {
        volume2 = SKSpriteNode(imageNamed: "volume2")
        volume2.name = "volume2"
        volume2.position = CGPoint(x: 500, y: 45)
        volume2.xScale = 0.07
        volume2.yScale = 0.07
        volume2.alpha = 0
        volume2.zPosition = 9
        addChild(volume2)
    }
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        setUpTitleLabel()
        setUpUfo()
        setUpMainBackground()
        setUpVolume()
        setUpVolume2()
        
        /* Set UI connections */
        playButton = self.childNodeWithName("playButton") as! MSButtonNode
        playButton.zPosition = 10
        
        insaneModeButton = self.childNodeWithName("insaneModeButton") as! MSButtonNode
        insaneModeButton.zPosition = 10
        
        /* Setup restart button selection handler */
        playButton.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = true
            skView.showsDrawCount = false
            skView.showsFPS = false
            skView.showsNodeCount = false

            
            /* Start game scene */
            let reveal: SKTransition = SKTransition.fadeWithDuration(2)
            skView.presentScene(scene, transition: reveal)
        }
        
        insaneModeButton.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = InsaneModeScene(fileNamed:"InsaneModeScene") as InsaneModeScene!
            
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = false
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            
            /* Start game scene */
            let reveal: SKTransition = SKTransition.fadeWithDuration(2)
            skView.presentScene(scene, transition: reveal)
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        //when touching the ufo
        let touch = touches.first
        let location = touch!.locationInNode(self)
        
        let node = nodeAtPoint(location)

        if node.name == "volume" {
            isFingerOnVolume = true
            volume.alpha = 0.5
            volume2.alpha = 1
            volume2.zPosition = 11
            SKTAudio.sharedInstance().pauseBackgroundMusic()
        }
        
        if node.name == "volume2" {
            isFingerOnVolume2 = true
            volume2.alpha = 0
            volume.alpha = 1
            volume2.zPosition = 9
            SKTAudio.sharedInstance().resumeBackgroundMusic()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?){
        isFingerOnVolume = false
        isFingerOnVolume2 = false
    }
    
}

