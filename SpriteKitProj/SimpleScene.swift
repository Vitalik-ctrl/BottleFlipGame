//
//  SimpleScene.swift
//  SpriteKitProj
//
//  Created by student on 05.08.2021.
//

import SpriteKit

class SimpleScene: SKScene {

    func changeToSceneBy(nameScene: String) {
        let scene = (nameScene == "GameScene") ? GameScene(size: self.size) : MenuScene(size: self.size)
        
        let transition = SKTransition.fade(with: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), duration: 0.3)
        
        scene.scaleMode = .aspectFill
        
        self.view?.presentScene(scene, transition: transition)
    }
    
}
