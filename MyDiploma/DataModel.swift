//
//  DataModel.swift
//  MyDiploma
//
//  Created by Булат Якупов on 09.05.17.
//  Copyright © 2017 Булат Якупов. All rights reserved.
//

import Foundation

class DataModel {
    
    static var dataModel = DataModel()
    
    var users = [User]()
    
    init() {
        print("\(documentsDirectory())")
        
        let path = dataFilePath()
        if FileManager.default.fileExists(atPath: path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiever = NSKeyedUnarchiver(forReadingWith: data as Data)
                users = unarchiever.decodeObject(forKey: "Users") as! [User]
                unarchiever.finishDecoding()
            }
        }
    }
    
    func save() {
        let data =  NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(users, forKey: "Users")
        archiver.finishEncoding()
        data.write(toFile: dataFilePath(), atomically: true)
    }
    
    func dataFilePath() -> String {
        return (documentsDirectory() as NSString).appendingPathComponent("MyDiploma.plis")
    }
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    func getUser(with login: String) -> User? {
        for user in users {
            if user.login == login {
                return user
            }
        }
        
        return nil
    }
}

class User: NSObject, NSCoding {
    var login: String!
    var passwords: [String]!
    
    var num4Inputs = UserInputs()
    var num5Inputs = UserInputs()
    var num6Inputs = UserInputs()
    
    init(login: String, passwords: [String]) {
        self.login = login
        self.passwords = passwords
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let inputs = aDecoder.decodeObject(forKey: "Num4Inputs") as? UserInputs {
            num4Inputs = inputs
        }
        if let inputs = aDecoder.decodeObject(forKey: "Num5Inputs") as? UserInputs {
            num5Inputs = inputs
        }
        if let inputs = aDecoder.decodeObject(forKey: "Num6Inputs") as? UserInputs {
            num6Inputs = inputs
        }
        login = aDecoder.decodeObject(forKey: "Login") as! String
        passwords = aDecoder.decodeObject(forKey: "Password") as! [String]
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(login, forKey: "Login")
        aCoder.encode(passwords, forKey: "Password")
        aCoder.encode(num4Inputs, forKey:"Num4Inputs")
        aCoder.encode(num5Inputs, forKey:"Num5Inputs")
        aCoder.encode(num6Inputs, forKey:"Num6Inputs")
    }
}
