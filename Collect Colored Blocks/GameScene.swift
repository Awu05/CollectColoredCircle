//
//  GameScene.swift
//  Collect Colored Blocks
//
//  Created by Andy Wu on 2/6/17.
//  Copyright © 2017 Andy Wu. All rights reserved.
//

import SpriteKit
import GameplayKit


var block0 = SKSpriteNode()
var block1 = SKSpriteNode()

var blockSize = CGSize(width: 70, height: 70)

var lblMain = SKLabelNode()
var lblScore = SKLabelNode()
var lblTimer = SKLabelNode()

var offBlackColor = UIColor(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 1)
var offWhiteColor = UIColor(colorLiteralRed: 0.98, green: 0.98, blue: 0.98, alpha: 1)
var orangeCustomColor = UIColor.orange
var blueCustomColor = UIColor(colorLiteralRed: 0.0, green: 0.5, blue: 0.7, alpha: 1)

var isBeingPlaced = false
var isCollecting = false
var isCompleted = false

var startTimerVar = 5
var placingTimerVar = 4
var collectingTimerVar = 5

var score = 0

var touchLocation = CGPoint()

var touchedNode = SKNode()

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        self.backgroundColor = offBlackColor
        resetGlobalVarsOnStart()
        spawnLblMain()
        spawnLblScore()
        spawnLblTimer()
        starterTimer()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            touchLocation = touch.location(in: self)
            touchedNode = atPoint(touchLocation)
            
            if isBeingPlaced == true {
                isBeingPlacedSpawnBlocks()
            }
            
            if isCollecting == true {
                isCollectingNodeLogic()
            }
        }
    }
    
    func resetGlobalVarsOnStart() {
        isBeingPlaced = false
        isCollecting = false
        isCompleted = false
        
        startTimerVar = 5
        placingTimerVar = 4
        collectingTimerVar = 5
        
        score = 0
    }
    
    func isBeingPlacedSpawnBlocks() {
        
        spawnBlock0()
        spawnBlock1()
        
    }
    
    func updateScore() {
        lblScore.text = "Score: \(score)"
    }
    
    func isCollectingNodeLogic() {
        if touchedNode.name == "block0Name" {
            touchedNode.removeFromParent()
            score = score + 1
            updateScore()
        }
        
        if touchedNode.name == "block1Name" {
            gameOverLogic()
        }
    }
    
    func spawnBlock0(){
        let randomPosX = CGFloat(arc4random_uniform(UInt32(self.frame.size.width - 60) + 60))
        let randomPosY = CGFloat(arc4random_uniform(UInt32(self.frame.size.height/2)))
        
        let randomNegX = CGFloat(arc4random_uniform(UInt32(self.frame.size.width - 60) + 60))
        let randomNegY = CGFloat(arc4random_uniform(UInt32(self.frame.size.height/2)))
        
        block0 = SKSpriteNode(imageNamed: "WhiteCircle")
        block0.size = blockSize
        block0.position = CGPoint(x: randomPosX + (randomNegX * -1), y: randomPosY + (randomNegY * -1))
        block0.name = "block0Name"
        rotateCircles()
        
        self.addChild(block0)
    }
    
    func spawnBlock1(){
        let randomPosX = CGFloat(arc4random_uniform(UInt32(self.frame.size.width - 60) + 60))
        let randomPosY = CGFloat(arc4random_uniform(UInt32(self.frame.size.height/2)))
        
        let randomNegX = CGFloat(arc4random_uniform(UInt32(self.frame.size.width - 60) + 60))
        let randomNegY = CGFloat(arc4random_uniform(UInt32(self.frame.size.height/2)))
        
        block1 = SKSpriteNode(imageNamed: "WhiteCircle")
        block1.size = blockSize
        block1.position = CGPoint(x: randomPosX + (randomNegX * -1), y: randomPosY + (randomNegY * -1))
        block1.name = "block1Name"
        rotateCircles()
        
        self.addChild(block1)
    }
    
    func rotateCircles() {
        let rotate = SKAction.rotate(byAngle: 1.5, duration: 1.0)
        
        block0.run(SKAction.repeatForever(rotate))
        block1.run(SKAction.repeatForever(rotate))
    }
    
    func spawnLblMain(){
        lblMain = SKLabelNode(fontNamed: "Futura")
        lblMain.fontColor = offWhiteColor
        lblMain.fontSize = 80
        lblMain.position = CGPoint(x: self.frame.midX, y: (self.frame.midY) + 180)
        
        lblMain.text = "Ready!"
        
        self.addChild(lblMain)
    }
    
    func spawnLblScore(){
        lblScore = SKLabelNode(fontNamed: "Futura")
        lblScore.fontColor = offWhiteColor
        lblScore.fontSize = 40
        lblScore.position = CGPoint(x: self.frame.midX, y: (self.frame.midY) + (self.frame.size.height * -0.48))
        
        lblScore.text = "Score: \(score)"
        
        self.addChild(lblScore)
    }
    
    func spawnLblTimer(){
        lblTimer = SKLabelNode(fontNamed: "Futura")
        lblTimer.fontColor = offWhiteColor
        lblTimer.fontSize = 70
        lblTimer.position = CGPoint(x: self.frame.midX, y: (self.frame.midY) + (self.frame.size.height * -0.38))
        lblTimer.text = "0"
        
        self.addChild(lblTimer)
        
    }
    
    func starterTimer(){
        let wait = SKAction.wait(forDuration: 1.0)
        let countDownTimer = SKAction.run {
            startTimerVar = startTimerVar - 1
            
            if startTimerVar <= 3 {
                lblMain.fontSize = 130
                lblMain.text = "Set \(startTimerVar)"
                
            }
            
            if startTimerVar <= 0 {
                lblMain.fontSize = 130
                lblMain.text = "GO!"
                lblMain.alpha = 0.5
                
                self.setGameStateVariables(isBeingPlacedTemp: true, isCollectingTemp: false, isCompletedTemp: false)
                
                self.isPlacingTimer()
            }
            
        }
        
        let sequence = SKAction.sequence([wait, countDownTimer])
        self.run(SKAction.repeat(sequence, count: startTimerVar))
    }
    
    func isPlacingTimer(){
        let wait = SKAction.wait(forDuration: 1.0)
        let countDownTimer = SKAction.run {
            placingTimerVar = placingTimerVar - 1
            
            lblMain.fontSize = 55
            lblMain.text = "Place Blocks"
            
            if placingTimerVar <= 3 {
                lblTimer.text = "\(placingTimerVar)"
            }
            
            if placingTimerVar <= 0 {
                self.backgroundColor = offWhiteColor
                lblMain.alpha = 1.0
                lblMain.fontColor = offBlackColor
                lblMain.zPosition = 1
                
                lblScore.fontColor = orangeCustomColor
                lblScore.zPosition = 1
                
                lblTimer.fontColor = orangeCustomColor
                lblTimer.zPosition = 1
                
                self.setGameStateVariables(isBeingPlacedTemp: false, isCollectingTemp: true, isCompletedTemp: false)
                
                self.isCollectingTimer()
                self.changeBlockColors()
            }
        }
        
        let sequence = SKAction.sequence([wait, countDownTimer])
        self.run(SKAction.repeat(sequence, count: placingTimerVar))
    }
    
    func isCollectingTimer() {
        lblMain.fontSize = 30
        lblMain.text = "Collect Orange Blocks"
        
        let wait = SKAction.wait(forDuration: 1.0)
        let countDownTimer = SKAction.run {
            collectingTimerVar = collectingTimerVar - 1
            
            if collectingTimerVar <= 5 && isCollecting == true {
                lblTimer.text = "\(collectingTimerVar)"
            }
            
            if collectingTimerVar <= 0 {
                self.setGameStateVariables(isBeingPlacedTemp: false, isCollectingTemp: false, isCompletedTemp: true)
                self.gameOverLogic()
            }
        }
        
        let sequence = SKAction.sequence([wait, countDownTimer])
        self.run(SKAction.repeat(sequence, count: collectingTimerVar))
    }
    
    func changeBlockColors() {
        if isCollecting == true {
            self.enumerateChildNodes(withName: "block0Name", using: { node, stop in
                
                if let sprite = node as? SKSpriteNode {
                    sprite.texture = SKTexture(imageNamed: "OrangeCircle")
                }
            })
            
            self.enumerateChildNodes(withName: "block1Name", using: { node, stop in
                
                if let sprite = node as? SKSpriteNode {
                    sprite.texture = SKTexture(imageNamed: "BlueCircle")
                }
            })
        }
    }
    
    func destroyAllBlocks() {
        self.enumerateChildNodes(withName: "block0Name", using: { node, stop in
            
            if let sprite = node as? SKSpriteNode {
                sprite.removeFromParent()
            }
        })
        
        self.enumerateChildNodes(withName: "block1Name", using: { node, stop in
            
            if let sprite = node as? SKSpriteNode {
                sprite.removeFromParent()
            }
        })
    }
    
    func gameOverLogic() {
        setGameStateVariables(isBeingPlacedTemp: false, isCollectingTemp: false, isCompletedTemp: true)
        
        destroyAllBlocks()
        
        self.backgroundColor = offBlackColor
        
        lblMain.text = "GAME OVER"
        lblMain.fontSize = 50
        lblMain.fontColor = offWhiteColor
        
        lblScore.fontColor = offWhiteColor
        
        lblTimer.fontColor = offWhiteColor
        
        resetTheGame()
    }
    
    func resetTheGame() {
        let wait = SKAction.wait(forDuration: 3.0)
        let theGameScene = GameScene(size: self.size)
        
        let theTransition = SKTransition.crossFade(withDuration: 0.6)
        
        self.view?.ignoresSiblingOrder = true
        theGameScene.scaleMode = .aspectFill
        
        let sceneChange = SKAction.run {
            self.scene?.view?.presentScene(theGameScene, transition: theTransition)
        }
        
        let sequence = SKAction.sequence([wait, sceneChange])
        self.run(SKAction.repeat(sequence, count: 1))
    }
    
    func setGameStateVariables(isBeingPlacedTemp: Bool, isCollectingTemp: Bool, isCompletedTemp: Bool){
        
        isBeingPlaced = isBeingPlacedTemp
        isCollecting = isCollectingTemp
        isCompleted = isCompletedTemp
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
