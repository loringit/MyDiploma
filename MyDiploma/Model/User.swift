//
//  User.swift
//  MyDiploma
//
//  Created by Булат Якупов on 09.05.17.
//  Copyright © 2017 Булат Якупов. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class User: Object {
    @objc dynamic var login = ""

    let passwordInfos = List<PasswordInfo>()
    
    override static func primaryKey() -> String? {
        return "login"
    }
}

class PasswordInfo: Object {
    @objc dynamic var password = ""
    
    let userAttempt = List<UserAttempt>()
}

class UserAttempt: Object {
    let attempt = List<Float32>()
}
