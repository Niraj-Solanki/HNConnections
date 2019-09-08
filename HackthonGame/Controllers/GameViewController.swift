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
    private let reachability = Reachability()!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setReachabilityNotifier()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func hitAPIAction(_ sender: Any) {
        switch Reachability.init()?.connection {
        case .wifi?:
            statusLabel.text = "Online Wifi"
        case .cellular?:
            statusLabel.text = "Online Celluler"
        case .none:
            print("Not Reachable")
            Reachability.init()?.showGame()
        case .some(.none):
            statusLabel.text = "Offline"
            Reachability.init()?.showGame()
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
    
    private func setReachabilityNotifier () {
        //declare this inside of viewWillAppear
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
