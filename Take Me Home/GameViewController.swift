//
//  GameViewController.swift
//  Take Me Home
//
//  Created by MakeSchool on 7/11/16.
//  Copyright (c) 2016 Jorge Avelar. All rights reserved.
//

import UIKit
import SpriteKit
import Firebase
import GoogleMobileAds


class GameViewController: UIViewController,GADInterstitialDelegate {
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = MainScene(fileNamed:"MainScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            skView.showsPhysics = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            
            interstitial = createAndLoadInterstetial()
            
            scene.viewController = self
    
        }
        SKTAudio.sharedInstance().playBackgroundMusic("backgroundMusic.mp3")
        
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func createAndLoadInterstetial() -> GADInterstitial {
        let request = GADRequest()
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-6965794389416906/6599556470")
        request.testDevices = ["115DA08F-6554-4F13-B05D-329CD542DCD4"]
        
        interstitial.delegate = self
        interstitial.loadRequest(request)
        return interstitial
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        interstitial = createAndLoadInterstetial()
    }
    
    func loadAd() {
        if interstitial != nil {
            if ((interstitial?.isReady) != nil) {
                interstitial?.presentFromRootViewController(self)
            }
        }
        
    }
}


