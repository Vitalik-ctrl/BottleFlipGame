//
//  LabelNode.swift
//  SpriteKitProj
//
//  Created by student on 04.08.2021.
//

import SpriteKit

class LabelNode: SKLabelNode {

    
     convenience init(text: String, fontSize: CGFloat, position: CGPoint, fontColor: UIColor) {
        self.init(fontNamed: UI_FONT)
        self.text = text
        self.fontSize = fontSize
        self.position = position
        self.fontColor = fontColor
        
    }
    

}
