//
//  GameViewController.swift
//  HackthonGame
//
//  Created by Neeraj Solanki on 04/09/19.
//  Copyright © 2019 Mr.Solanki. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import SystemConfiguration

class GameViewController: UIViewController {
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.raywenderlich.com")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsPhysics = false
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    private func checkReachable()
    {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(self.reachability!, &flags)
        
        if (isNetworkReachable(with: flags))
        {
            print (flags)
            if flags.contains(.isWWAN) {
                self.alert(message:"via mobile",title:"Reachable")
                return
            }
            
            self.alert(message:"via wifi",title:"Reachable")
        }
        else if (!isNetworkReachable(with: flags)) {
            self.alert(message:"Sorry no connection",title: "unreachable")
            print (flags)
            return
        }
    }
    
    
    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    /*
     private func setReachabilityNotifier () {
     //declare this inside of viewWillAppear
     
     NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
     do{
     try reachability.startNotifier()
     }catch{
     print("could not start reachability notifier")
     }
     }
     */
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


//MARK:- Alert View-
extension UIViewController
{
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        
        DispatchQueue.main.async  {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
