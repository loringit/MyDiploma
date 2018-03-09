//
//  PassCodeVM.swift
//  MyDiploma
//
//  Created by Булат Якупов on 03.03.18.
//  Copyright © 2018 Булат Якупов. All rights reserved.
//

import Foundation

enum AnalysisResult {
    case success(String)
    case error(String)
}

protocol PassCodeVMDelegate {
    func showLoader()
    func show(_ result: AnalysisResult)
    func update(for attempts: Int)
}

class PassCodeVM {
    
    private var passcode = [Int]()
    private var touchesSet = [Float32]()
    private var password: String
    var supposedLen: Int
    var attempts: Int {
        didSet {
            delegate?.update(for: attempts)
        }
    }
    private var user: User
    
    var delegate: PassCodeVMDelegate?
    
    init(with supposedLen: Int, for user: User) {
        self.supposedLen = supposedLen
        self.user = user
        
        switch supposedLen {
        case 4:
            attempts = user.num4Inputs.attempt
            password = user.passwords[0]
        case 5:
            attempts = user.num5Inputs.attempt
            password = user.passwords[1]
        case 6:
            attempts = user.num6Inputs.attempt
            password = user.passwords[2]
        default:
            attempts = 0
            password = ""
            break
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
            switch supposedLen {
            case 4:
                user.num4Inputs.userAttempts.append(touchesSet)
                user.num4Inputs.attempt += 1
                attempts = user.num4Inputs.attempt
            case 5:
                user.num5Inputs.userAttempts.append(touchesSet)
                user.num5Inputs.attempt += 1
                attempts = user.num5Inputs.attempt
            case 6:
                user.num6Inputs.userAttempts.append(touchesSet)
                user.num6Inputs.attempt += 1
                attempts = user.num6Inputs.attempt
            default:
                break
            }
            
            DataModel.dataModel.save()
            
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
