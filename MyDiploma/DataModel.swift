//
//  User.swift
//  MyDiploma
//
//  Created by Булат Якупов on 22.10.16.
//  Copyright © 2016 Булат Якупов. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class DataModel {
    var userAttempts: [[Float32]] = []
    var attempt = 0
    
    func loadTouches() {
        print("\(documentsDirectory())")
        
        let path = dataFilePath()
        if FileManager.default.fileExists(atPath: path) {
            print("[")
            if let data = NSData(contentsOfFile: path) {
                let unarchiever = NSKeyedUnarchiver(forReadingWith: data as Data)
                userAttempts = unarchiever.decodeObject(forKey: "UserAttempts") as! [[Float32]]
                attempt = unarchiever.decodeInteger(forKey: "Attempt")
                unarchiever.finishDecoding()
            }
        }
    }
    
    func saveTouches() {
        let data =  NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(userAttempts, forKey: "UserAttempts")
        archiver.encode(attempt, forKey: "Attempt")
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
    
    init() {
        loadTouches()
        
    }
    
    func registerDefaults() {
        let dictionary = ["FirstTime": true]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        if firstTime {
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
}
