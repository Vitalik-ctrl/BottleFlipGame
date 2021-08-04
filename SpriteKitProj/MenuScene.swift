//
//  MenuScene.swift
//  SpriteKitProj
//
//  Created by student on 04.08.2021.
//

import SpriteKit

class MenuScene: SKScene {

    var playButtonNode = SKSpriteNode()
    var tableNode = SKSpriteNode()
    var bottleNode = SKSpriteNode()
    var leftButtonNode = SKSpriteNode()
    var rightButtonNode = SKSpriteNode()
    
    var selectedBottleIndex = 0
    var highScore = 0
    var totalFlips = 0
    var bottles = [Bottle]()
    var totalBottles = 0
    
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
        let bestScoreLabelNode = LabelNode(text: "BEST RESULT", fontSize: 16, position: CGPoint(x: self.frame.midX - 70, y: self.frame.maxY - 140), fontColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
        self.addChild(bestScoreLabelNode)
        
        // High Score Label
        let highScoreLabelNode = LabelNode(text: "\(highScore)", fontSize: 24, position: CGPoint(x: self.frame.midX - 70, y: self.frame.maxY - 175), fontColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
        self.addChild(highScoreLabelNode)
        
        // Total Flips Label
        let totalFlipsLabelNode = LabelNode(text: "FLIPS' COUNT", fontSize: 16, position: CGPoint(x: self.frame.midX + 70, y: self.frame.maxY - 140), fontColor: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1))
        self.addChild(totalFlipsLabelNode)
        
        // Total Flips Score Label
        let flipsLabelNode = LabelNode(text: "\(totalFlips)", fontSize: 24, position: CGPoint(x: self.frame.midX + 70, y: self.frame.maxY - 175), fontColor: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1))
        self.addChild(flipsLabelNode)
        
        // Play Button
        playButtonNode = ButtonNode(imageNode: "PlayBtn", position: CGPoint(x: self.frame.midX, y: self.frame.midY), xScale: 0.6, yScale: 0.6)
        self.addChild(playButtonNode)
        
        // Table Node
        tableNode = ButtonNode(imageNode: "table", position: CGPoint(x: self.frame.midX, y: self.frame.minY + 30), xScale: 0.3, yScale: 0.3)
        tableNode.zPosition = 3
        self.addChild(tableNode)
        
        // Bottle Node
        selectedBottleIndex = BottleController.getSaveBottleIndex()
        let selectedBottle = bottles[selectedBottleIndex]
        bottleNode = SKSpriteNode(imageNamed: selectedBottle.Sprite!)
        bottleNode.zPosition = 10
        self.addChild(bottleNode)
        
        // Left Button
        leftButtonNode = ButtonNode(imageNode: "chevron_left", position: CGPoint(x: self.frame.midX - 90, y: self.frame.minY + 125), xScale: 0.15, yScale: 0.15)
        self.changeButton(buttonNode: leftButtonNode, state: false)
        self.addChild(leftButtonNode)
        
        // Right Button
        rightButtonNode = ButtonNode(imageNode: "chevron_right", position: CGPoint(x: self.frame.midX + 90, y: self.frame.minY + 125), xScale: 0.15, yScale: 0.15)
        self.changeButton(buttonNode: rightButtonNode, state: true)
        self.addChild(rightButtonNode)
        
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
        bottleNode.texture = SKTexture(imageNamed: bottle.Sprite!)
        
        bottleNode.size = CGSize(
            width: bottleNode.texture!.size().width * CGFloat(bottle.XScale!.floatValue),
            height: bottleNode.texture!.size().height * CGFloat(bottle.YScale!.floatValue))
        
        bottleNode.position = CGPoint(x: self.frame.midX, y: self.frame.minY + bottleNode.size.height/2 + 79)
        
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
    
}
