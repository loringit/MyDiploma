//
//  User.swift
//  MyDiploma
//
//  Created by Булат Якупов on 22.10.16.
//  Copyright © 2016 Булат Якупов. All rights reserved.
//

import Foundation
import UIKit

class UserInputs: NSObject, NSCoding {
    var userAttempts: [[Float32]] = []
    var attempt = 0
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        userAttempts = aDecoder.decodeObject(forKey: "UserAttempts") as! [[Float32]]
        attempt = aDecoder.decodeInteger(forKey: "Attempt")
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userAttempts, forKey: "UserAttempts")
        aCoder.encode(attempt, forKey: "Attempt")
    }
}
