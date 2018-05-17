//
//  PassCodeVM.swift
//  MyDiploma
//
//  Created by Булат Якупов on 03.03.18.
//  Copyright © 2018 Булат Якупов. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

enum AnalysisResult {
    case success(String)
    case error(String)
}

protocol PassCodeVMDelegate: class {
    func showLoader()
    func show(_ result: AnalysisResult)
    func update(for attempts: Int)
}

class PassCodeVM {
    
    private var passcode = [Int]()
    private var touchesSet = [Float32]()
    private var password = ""
    var supposedLen = 0
    var attempts: Int = 0 {
        didSet {
            delegate?.update(for: attempts)
        }
    }
    private var user: User
    
    weak var delegate: PassCodeVMDelegate?
    
    init(with supposedLen: Int, for user: User) {
        self.supposedLen = supposedLen
        self.user = user
        
        for passwordInfo in user.passwordInfos {
            if passwordInfo.password.count == supposedLen {
                self.password = passwordInfo.password
                self.attempts = passwordInfo.userAttempt.count
            }
        }
    }
    
    func add(num: Int) {
        passcode.append(num)
    }
    
    func add(touchTime: Float32) {
        touchesSet.append(touchTime)
        
        if touchesSet.count == supposedLen * 2 {
            delegate?.showLoader()
            verifyPasscode()
        }
    }
    
    private func verifyPasscode() {
        var enteredPasscode = ""
        
        for i in 0..<passcode.count {
            enteredPasscode = enteredPasscode + String(passcode[i])
        }
        
        if passcode.count < 4 || passcode.count > 6 {
            delegate?.show(.error("Not enough characters"))
        }
        
        if enteredPasscode == password {
            for passwordInfo in user.passwordInfos {
                if passwordInfo.password == password {
                    
                    let newAttempt = UserAttempt()
                    newAttempt.attempt.append(objectsIn: touchesSet)
                    
                    let realm = try! Realm()
                    try! realm.write {
                        passwordInfo.userAttempt.append(newAttempt)
                    }
                    
                    attempts += 1
                }
            }
            
            delegate?.show(.success("You entered password \(attempts + 1) times!"))
        } else {
            delegate?.show(.error("Entered wrong passcode!"))
        }
    }
    
    func clearInput() {
        passcode.removeAll()
        touchesSet.removeAll()
    }
}
