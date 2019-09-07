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

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    //Objects
    private var screenSize:CGSize!
    var actor = SKSpriteNode.init(imageNamed: "actor")
    var scoreLabel = SKLabelNode.init(text: "Score :")
    var highScoreLabel = SKLabelNode.init(text: "HI : ")
    var gameOverLabel = SKLabelNode.init(text: "Game Over \nTap to play")
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var gameLevelImage = 0
    var highScore = 0
    var itemLimits = 10
    var lastLimit = 10
    var gravityValue = -0.8
    
    var isGameOver = true
    var isActorHold = false
    
    //Life Cycle
    override func didMove(to view: SKView) {
        initializeVariables()
        self.size = screenSize
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector.init(dx: 0, dy: gravityValue)
    }
    
    //Initilizer
    private func initializeVariables() {
        screenSize = CGSize.init(width: UIScreen.main.bounds.size.width * 2, height: UIScreen.main.bounds.size.height * 2)
        
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "Tap to Play"
        gameOverLabel.fontColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.position = CGPoint(x: 0, y: 0)
        addChild(gameOverLabel)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: (-screenSize.width / 2) + scoreLabel.frame.size.width + 50, y: (screenSize.height / 2) - 100)
        addChild(scoreLabel)
        
        highScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        highScoreLabel.text = "HI: 0"
        highScoreLabel.fontColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        highScoreLabel.horizontalAlignmentMode = .right
        highScoreLabel.position = CGPoint(x: (screenSize.width / 2) - (highScoreLabel.frame.size.width / 2), y: (screenSize.height / 2) - 100)
        addChild(highScoreLabel)
        
        actor = generateSpriteNode(texture: "bowl", position: CGPoint.init(x: 0, y: -(screenSize.height / 2) + 100), size: CGSize.init(width: 150, height: 100))
        actor.name = "actor"
        actor.applyPhysics(isDynamic: false)
        addChild(actor)
        
        let rain = SKEmitterNode.init(fileNamed: "RainParticle.sks")
        rain?.position = CGPoint.init(x: 0, y: screenSize.height / 2)
        addChild(rain!)
        setUpBorders()
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
    
    
    //Generate SpriteNode With Texture & Position, Size
    func generateSpriteNode(texture:String,position:CGPoint,size:CGSize) -> SKSpriteNode {
        let node = SKSpriteNode.init(imageNamed: texture)
        node.size = size
        node.position = position
        node.applyPhysics(isDynamic: true)
        return node
    }
    
    // Generate Random Number Between Numbers
    func getRandomNumber(start:Int,end:Int) -> Int {
        return Int.random(in: start ..< end)
    }
    
    //MARK:- Items Generate Timer
    func gameNodeGenerateTimer() {
        let wait = SKAction.wait(forDuration: 0.8)
        let run = SKAction.run {
            self.itemLimits = self.itemLimits - 1
            let randNo = self.getRandomNumber(start: 0, end: 14)
            
            let item = self.generateSpriteNode(texture: "apple", position: CGPoint.init(x: self.getRandomNumber(start: Int(-self.screenSize.width / 2), end: Int(self.screenSize.width / 2)), y: self.getRandomNumber(start: Int(self.screenSize.height / 2), end: Int(self.screenSize.height / 2) + 300)), size: CGSize.init(width: 80, height: 80))
            
            if randNo > 10
            {
                item.name = "badItem"
                item.texture = SKTexture.init(imageNamed: "\(randNo)")
            }
            else{
                item.name = "goodItem"
                item.texture = SKTexture.init(imageNamed: "\(self.gameLevelImage)")
            }
            self.addChild(item)
        }
        let sequence = SKAction.sequence([wait,run])
        let action = SKAction.repeat(sequence, count: itemLimits)
        self.run(action)
    }
    
  
    
    //MARK:- Touch Handle
    func touchMovesInPoint(point:CGPoint)  {
        if isActorHold{
            var newPoint = point
            newPoint.y = (-(screenSize.height / 2) + 100)
            
            //Move Actor in scene
            if((newPoint.x > -screenSize.width / 2) && (newPoint.x < screenSize.width / 2))
            {
                actor.position  = newPoint
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isGameOver {
            gameOverLabel.isHidden = true
            gameReset()
            return
        }
        
        let touch = touches.first
        let positionInScene = touch?.location(in: self)
        for node in nodes(at: positionInScene!) {
            
            if (node.name == "actor") || (node.name == "background")
            {
                isActorHold = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver
        {
            return
        }
        
        if isActorHold {
            
            for touch in touches
            {
                touchMovesInPoint(point: touch.location(in: self))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isActorHold = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isActorHold = false
    }
    
    
    //MARK:- Collision
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "goodItem" && contact.bodyB.node?.name == "actor"{
            contact.bodyA.node?.removeFromParent()
            score = score + 1
        }
        else if contact.bodyB.node?.name == "goodItem" && contact.bodyA.node?.name == "actor" {
            contact.bodyB.node?.removeFromParent()
            score = score + 1
        }
        else if contact.bodyA.node?.name == "badItem" && contact.bodyB.node?.name == "actor" {
            isGameOver = true
            gameOver()
            
        }
        else if contact.bodyB.node?.name == "badItem" && contact.bodyA.node?.name == "actor" {
            isGameOver = true
            gameOver()
        }
        else if contact.bodyA.node?.name == "badItem" || contact.bodyA.node?.name == "goodItem"
        {
            contact.bodyA.node?.removeFromParent()
        }
        else if contact.bodyB.node?.name == "badItem" || contact.bodyB.node?.name == "goodItem"
        {
            contact.bodyB.node?.removeFromParent()
        }
    }
    
    //MARK:- Game Over & Reset
    func gameOver() {
        self.isPaused = true
        if highScore < score {
            highScoreLabel.text = "HI : \(score)"
            highScore = score
            gameOverLabel.text = "GAME OVER \n Tap To Play"
            gameOverLabel.isHidden = false
        }
    }
    
    func gameReset() {
        
        for node in self.children {
            if node.name == "goodItem" || node.name == "badItem"
            {
                node.removeFromParent()
            }
        }
        
        isGameOver = false
        self.physicsWorld.gravity = CGVector.init(dx: 0, dy: gravityValue)
        itemLimits = 20
        score = 0
        gravityValue = -0.8
        self.isPaused = false
        gameNodeGenerateTimer()
    }
    
    //MARK:- Update Game
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if itemLimits < 1 {
            lastLimit = lastLimit + 5
            itemLimits = lastLimit
            gravityValue = gravityValue - -0.5
            if gameLevelImage < 10
            {
                gameLevelImage = gameLevelImage + 1
            }
            else
            {
                gameLevelImage  = 0
            }
            gameNodeGenerateTimer()
        }
    }
}

extension SKSpriteNode
{
    //Apply Physics Body
    func applyPhysics(isDynamic:Bool) {
        self.physicsBody = SKPhysicsBody.init(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.isDynamic = isDynamic
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.restitution = 0.0001
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
}


