//
//  MenuScene.swift
//  SpriteKitProj
//
//  Created by student on 04.08.2021.
//

import SpriteKit

class MenuScene: SimpleScene {

    var playButtonNode = SKSpriteNode()
    var tableNode = SKSpriteNode()
    var bottleNode = SKSpriteNode()
    var leftButtonNode = SKSpriteNode()
    var rightButtonNode = SKSpriteNode()
    var flipsTagNode = SKSpriteNode()
    var unlockLabelNode = SKLabelNode()
    var back = SKSpriteNode()
    
    
    var selectedBottleIndex = 0
    var highScore = 0
    var totalFlips = 0
    var bottles = [Bottle]()
    var totalBottles = 0
    var isLockButton = false
    
    
    
    
    override func didMove(to view: SKView) {
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // Loading Bottles From Items.plist
        bottles = BottleController.readItems()
        totalBottles = bottles.count
        
        
        setupUI()
    }
    
    func setupUI() {
        // Logo Node
        let logo = ButtonNode(imageNode: "Logo", position: CGPoint(x: self.frame.midX, y: self.frame.maxY - 60), xScale: 0.6, yScale: 0.6)
        self.addChild(logo)
        
        // Best Score Label
        let bestScoreLabelNode = LabelNode(text: "BEST RESULT", fontSize: 16, position: CGPoint(x: self.frame.midX - 70, y: self.frame.maxY - 140), fontColor: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1))
        self.addChild(bestScoreLabelNode)
        
        // High Score Label
        let highScoreLabelNode = LabelNode(text: "\(highScore)", fontSize: 24, position: CGPoint(x: self.frame.midX - 70, y: self.frame.maxY - 175), fontColor: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1))
        self.addChild(highScoreLabelNode)
        
        // Total Flips Label
        let totalFlipsLabelNode = LabelNode(text: "FLIPS' COUNT", fontSize: 16, position: CGPoint(x: self.frame.midX + 70, y: self.frame.maxY - 140), fontColor: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1))
        self.addChild(totalFlipsLabelNode)
        
        // Total Flips Score Label
        let flipsLabelNode = LabelNode(text: "\(totalFlips)", fontSize: 24, position: CGPoint(x: self.frame.midX + 70, y: self.frame.maxY - 175), fontColor: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1))
        self.addChild(flipsLabelNode)
        
        // Play Button
        playButtonNode = ButtonNode(imageNode: "PlayBtn", position: CGPoint(x: self.frame.midX, y: self.frame.midY), xScale: 1, yScale: 1)
        self.addChild(playButtonNode)
        
        // Table Node
        tableNode = ButtonNode(imageNode: "table", position: CGPoint(x: self.frame.midX, y: self.frame.minY - 11), xScale: 0.55, yScale: 0.45)
        tableNode.zPosition = 3
        self.addChild(tableNode)
        
        // Bottle Node
        selectedBottleIndex = BottleController.getSaveBottleIndex()
        let selectedBottle = bottles[selectedBottleIndex]
        bottleNode = SKSpriteNode(imageNamed: selectedBottle.Sprite!)
        bottleNode.zPosition = 10
        self.addChild(bottleNode)
        
        // Left Button
        leftButtonNode = ButtonNode(imageNode: "chevron_left", position: CGPoint(x: self.frame.midX - 100, y: self.frame.minY + 120), xScale: 0.17, yScale: 0.17)
        self.changeButton(buttonNode: leftButtonNode, state: false)
        self.addChild(leftButtonNode)
        
        // Right Button
        rightButtonNode = ButtonNode(imageNode: "chevron_right", position: CGPoint(x: self.frame.midX + 100, y: self.frame.minY + 120), xScale: 0.17, yScale: 0.17)
        self.changeButton(buttonNode: rightButtonNode, state: true)
        self.addChild(rightButtonNode)
        
        // Unlock Label
        unlockLabelNode = LabelNode(text: "0 to unlock", fontSize: 18, position: CGPoint(x: self.frame.midX, y: self.frame.midY - 129), fontColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
        unlockLabelNode.zPosition = 28
        self.addChild(unlockLabelNode)
        
        // Unlock Label Background
        back = ButtonNode(imageNode: "text_back", position: CGPoint(x: self.frame.midX, y: self.frame.midY - 122), xScale: 0.48, yScale: 0.6)
        back.alpha = 0.7
        back.zPosition = 12
        self.addChild(back)
        
        
        
        
        // Update Selected Bottle
        self.updateSelectedBottle(selectedBottle)
        
    }
    
    func changeButton(buttonNode: SKSpriteNode, state: Bool) {
        // Change arrow sprites
        var buttonColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4023053435)
        if state {
            buttonColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        buttonNode.color = buttonColor
        buttonNode.colorBlendFactor = 1
        
    }
    
    func updateSelectedBottle(_ bottle: Bottle){
        
        // Update to the selected bottle
        let unlockFlips = bottle.MinFlips!.intValue - highScore
        let unlocked = unlockFlips <= 0
        
        
        
        flipsTagNode.isHidden = unlocked
        unlockLabelNode.isHidden = unlocked
        back.isHidden = unlocked
        
        bottleNode.texture = SKTexture(imageNamed: bottle.Sprite!)
        bottleNode.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6555960519)
        if unlocked {
            bottleNode.colorBlendFactor = 0
            pulseStartNode(playButtonNode)
        } else {
            playButtonNode.removeAllActions()
            bottleNode.colorBlendFactor = 1
            
        }
        playButtonNode.texture = SKTexture(imageNamed: (unlocked ? "PlayBtn": "lock"))
        
        isLockButton = !unlocked
        
        bottleNode.size = CGSize(
            width: bottleNode.texture!.size().width * CGFloat(bottle.XScale!.floatValue),
            height: bottleNode.texture!.size().height * CGFloat(bottle.YScale!.floatValue))
        
        bottleNode.position = CGPoint(x: self.frame.midX, y: self.frame.minY + bottleNode.size.height/2 + 78)
        
        unlockLabelNode.text = "\(bottle.MinFlips!.intValue) to unlock"
        
        self.updateArrowsState()
        
    }
    
    func updateArrowsState() {
        // Update Arrows State
        
        self.changeButton(buttonNode: leftButtonNode, state: Bool(selectedBottleIndex as NSNumber))
        self.changeButton(buttonNode: rightButtonNode, state: selectedBottleIndex != totalBottles - 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self)
            
            // Play button is pressed
            if playButtonNode.contains(location) {
                self.startGame()
            }
            
            // Left button is pressed
            if leftButtonNode.contains(location) {
                 let prevIndex = selectedBottleIndex - 1
                if prevIndex >= 0 {
                    self.updateByIndex(prevIndex)
                }
            }
            
            // Right button is pressed
            if rightButtonNode.contains(location) {
                 let nextIndex = selectedBottleIndex + 1
                if nextIndex < totalBottles {
                    self.updateByIndex(nextIndex)
                }
            }
            
        }
    }
    func updateByIndex(_ index: Int) {
        // Update based on Index
        let bottle = bottles[index]
        
        selectedBottleIndex = index
        
        self.updateSelectedBottle(bottle)
        BottleController.saveSelectedBottle(selectedBottleIndex)
    }
    
    func pulseStartNode(_ node: SKSpriteNode) {
        // Pulse animation for lock
    
        let scaleDownAction = SKAction.scale(to: 1, duration: 0.5)
        let scaleUpAction = SKAction.scale(to: 1.2, duration: 0.5)
        let seq = SKAction.sequence([scaleDownAction, scaleUpAction])
        
        node.run(SKAction.repeatForever(seq))
        
        
    }
    
    func startGame() {
        // Not Lock button -> start game
        if !isLockButton {
            self.changeToSceneBy(nameScene: "GameScene")
    }
    
}
}
