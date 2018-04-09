//
//  Worklist.swift
//  WorkList
//
//  Created by LALIT JAGTAP on 3/30/18.
//  Copyright © 2018 LALIT JAGTAP. All rights reserved.
//

import UIKit


class Worklist: NSObject, Codable {
    var name = ""
    var items = [WorklistItem] ()
    var iconName = "No Icon"

    init(name: String, iconName: String = "No icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItems()->Int {
        var count = 0
        
        for item in items where !item.checked {
            count += 1
        }
        
        return count
    }
    
}
