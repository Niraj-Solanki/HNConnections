//
//  GameScene.swift
//  HackthonGame
//
//  Created by Neeraj Solanki on 04/09/19.
//  Copyright © 2019 Mr.Solanki. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var screenSize:CGSize!
    
    override func didMove(to view: SKView) {
        initializeVariables()
        self.size = screenSize
       self.physicsWorld.gravity = CGVector.init(dx: 0, dy: -9.8)
        
    }
    
    //Initilizer
    private func initializeVariables() {
        screenSize = CGSize.init(width: UIScreen.main.bounds.size.width * 2, height: UIScreen.main.bounds.size.height * 2)
        setUpBorders()
        addChild(generateSpriteNode(texture: "apple",position: CGPoint.init(x: 0, y: 0),size:CGSize.init(width: 50, height: 50)))
    }
    
    
    //Setup Borders
    func setUpBorders() {
        
        // Bottom Border
        let bottomBorder = SKSpriteNode.init(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), size: CGSize.init(width: screenSize.width * 2, height:1))
        bottomBorder.position = CGPoint.init(x: 0, y: -screenSize.height / 2)
        bottomBorder.applyPhysics(isDynamic: false)
        addChild(bottomBorder)
        
        // Left Border
        let leftBorder = SKSpriteNode.init(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), size: CGSize.init(width: 1, height:screenSize.height))
        leftBorder.position = CGPoint.init(x: -screenSize.width / 2, y: 0)
        leftBorder.applyPhysics(isDynamic: false)
        addChild(leftBorder)
        
        // Right Border
        let rightBorder = SKSpriteNode.init(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), size: CGSize.init(width: 1, height:screenSize.height))
        rightBorder.position = CGPoint.init(x: screenSize.width / 2, y: 0)
        rightBorder.applyPhysics(isDynamic: false)
        addChild(rightBorder)
    }
    
    func generateSpriteNode(texture:String,position:CGPoint,size:CGSize) -> SKSpriteNode {
        let node = SKSpriteNode.init(imageNamed: texture)
        node.size = size
        node.position = position
        node.applyPhysics(isDynamic: true)
        return node
    }
    
    //MARK:- Update Game
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

extension SKSpriteNode
{
    //Apply Physics Body
    func applyPhysics(isDynamic:Bool) {
        self.physicsBody = SKPhysicsBody.init(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.isDynamic = isDynamic
    }
}
