//
//  BottleController.swift
//  SpriteKitProj
//
//  Created by student on 04.08.2021.
//

import Foundation

class BottleController {
    
    class func readItems() -> [Bottle] {
        // Reading items from plist
        var bottles = [Bottle]()
        if let path = Bundle.main.path(forResource: "Items", ofType: "plist"), let plistArray = NSArray (contentsOfFile: path) as? [[String: Any]] {
            for dictionary in plistArray {
                let bottle = Bottle(dictionary as NSDictionary)
                bottles.append(bottle)
            }
        }
        return bottles
        
    }
    
    class func saveSelectedBottle(_ index: Int) {
        // Save index
        UserDefaults.standard.set(index, forKey: "selectedBottle")
        UserDefaults.standard.synchronize()
    }
    
    class func  getSaveBottleIndex() -> Int {
        // Get saved index
        return UserDefaults.standard.integer(forKey: "selectedBottle")
    }
    
}
