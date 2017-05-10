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
    
    var numInputs = UserInputs()
    var graphInputs = UserInputs()
    
    init(login: String, passwords: [String]) {
        self.login = login
        self.passwords = passwords
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        loadUser()
    }
    
    func encode(with aCoder: NSCoder) {
        saveUser()
    }

    func saveUser() {
        let data =  NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(login, forKey: "Login")
        archiver.encode(passwords, forKey: "Password")
        archiver.encode(numInputs, forKey:"NumInputs")
        archiver.encode(graphInputs, forKey:"GraphInputs")
        archiver.finishEncoding()
        data.write(toFile: dataFilePath(), atomically: true)
    }
    
    func loadUser() {
        print("\(documentsDirectory())")
        
        let path = dataFilePath()
        if FileManager.default.fileExists(atPath: path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiever = NSKeyedUnarchiver(forReadingWith: data as Data)
                numInputs = unarchiever.decodeObject(forKey: "NumInputs") as! UserInputs
                graphInputs = unarchiever.decodeObject(forKey: "GraphInputs") as! UserInputs
                login = unarchiever.decodeObject(forKey: "Attempt") as! String
                passwords = unarchiever.decodeObject(forKey: "Attempt") as! [String]
                unarchiever.finishDecoding()
            }
        }
    }
    
    func dataFilePath() -> String {
        return (documentsDirectory() as NSString).appendingPathComponent("MyDiploma.plis")
    }
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
}
