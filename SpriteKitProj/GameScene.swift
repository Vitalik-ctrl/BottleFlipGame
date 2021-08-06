//
//  GameScene.swift
//  SpriteKitProj
//
//  Created by student on 04.08.2021.
//

import SpriteKit

class GameScene: SimpleScene {
    
    var scoreLabelNode = SKLabelNode()
    var highscoreLabelNode = SKLabelNode()
    
    var backButtonNode = SKSpriteNode()
    var resetButtonNode = SKSpriteNode()
    var tutorialNode = SKSpriteNode()
    var bottleNode = SKSpriteNode()
    var didSwipe = false
    var start = CGPoint.zero
    var startTime = TimeInterval()
    
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        // Settings for scene
        self.physicsBody?.restitution = 0
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.setupUINodes()
        self.setupGameNodes()
    }
    
    
    
    func setupGameNodes() {
        
        // Table Node
        let tableNode = SKSpriteNode(imageNamed: "table")
        
        tableNode.physicsBody = SKPhysicsBody(rectangleOf: tableNode.texture!.size())
        tableNode.physicsBody?.affectedByGravity = false
        tableNode.physicsBody?.isDynamic = false
        tableNode.physicsBody?.restitution = 0
        tableNode.xScale = 0.6
        tableNode.yScale = 0.45
        
        tableNode.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 5)
        self.addChild(tableNode)
        
        // Bottle Node
        let selectedBottle = BottleController.readItems()[BottleController.getSaveBottleIndex()]
        bottleNode = BottleNode(selectedBottle as! Bottle)
        
        addChild(bottleNode)
        
    }
    
    func setupUINodes() {
        // Score Label Node
        scoreLabelNode = LabelNode(text: "0", fontSize: 64, position: CGPoint(x: self.frame.midX, y: self.frame.midY + 10), fontColor: #colorLiteral(red: 0.2754490505, green: 0.6874981123, blue: 0.4588300243, alpha: 0.5))
        scoreLabelNode.zPosition = -1
        self.addChild(scoreLabelNode)
        
        // High Score Label Node
        //        highscoreLabelNode = LabelNode(text: "FLIPS' COUNT", fontSize: 24, position: CGPoint(x: self.frame.midX, y: self.frame.midY + 10), fontColor: #colorLiteral(red: 0.559041384, green: 0.5229988426, blue: 1, alpha: 0.5))
        //        highscoreLabelNode.zPosition = -1
        //        self.addChild(highscoreLabelNode)
        
        // Back Button
        backButtonNode = ButtonNode(imageNode: "back", position: CGPoint(x: self.frame.minX + 30, y: self.frame.maxY - 30) , xScale: 0.07, yScale: 0.07)
        addChild(backButtonNode)
        
        // Reset Button
        resetButtonNode = ButtonNode(imageNode: "reload", position: CGPoint(x: self.frame.maxX - 30, y: self.frame.maxY - 30) , xScale: 0.07, yScale: 0.07)
        addChild(resetButtonNode)
        
        // Tutorial Button
        let tutorialFinished = UserDefaults.standard.bool(forKey: "tutorialFinished")
        tutorialNode = ButtonNode(imageNode: "tutorial", position: CGPoint(x: self.frame.midX, y: self.frame.midY), xScale: 1, yScale: 1)
        tutorialNode.isHidden = tutorialFinished
        tutorialNode.zPosition = 5
        addChild(tutorialNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Start recording touches
        
        if touches.count > 1 {
            return
        }
        
        let touch = touches.first
        let location = touch?.location(in: self)
        start = location!
        startTime = touch!.timestamp
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if backButtonNode.contains(location) {
                self.changeToSceneBy(nameScene: "MenuScene")
            }
            
            if resetButtonNode.contains(location) {
                resetBottle()
            }
            
            if tutorialNode.contains(location) {
                tutorialNode.isHidden = true
                UserDefaults.standard.set(true, forKey: "tutorialFinished")
            }
        }
        // Bottle flipping logic
        if !didSwipe {
            // V = S/t
            // S = sqrt(x * x + y * y)
            // x = x2 - x1, y = y2 - y1
            let touch = touches.first
            let location = touch?.location(in: self)
            let x = location!.x - start.x
            let y = location!.y - start.y
            
            let distance = sqrt(x*x + y*y)
            let time = CGFloat(touch!.timestamp - startTime)
            
            if distance >= 20 && y > 0 {
                let speed = distance/time
                
                if speed >= 20 {
                    // Add angular velocity impulse
                    bottleNode.physicsBody?.angularVelocity = 5.1 * (abs(x) / x) * (-1)
                    bottleNode.physicsBody?.applyImpulse(CGVector(dx: x * 0.5, dy: distance * 1.8))
                    
                    didSwipe = true
                }
            }
            
            
            
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func resetBottle() {
        // Reset bottle
        bottleNode.position = CGPoint(x: self.frame.midX, y: bottleNode.size.height * 1.5)
        bottleNode.physicsBody?.angularVelocity = 0
        bottleNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bottleNode.speed = 0
        bottleNode.zRotation = 0
        didSwipe = false
        
    }
}
