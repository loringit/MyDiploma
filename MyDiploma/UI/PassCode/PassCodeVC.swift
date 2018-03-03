//
//  PassCodeVC.swift
//  MyDiploma
//
//  Created by Булат Якупов on 04.10.16.
//  Copyright © 2016 Булат Якупов. All rights reserved.
//

import Foundation
import UIKit

enum AnalysisResult {
    case success(String)
    case error(String)
}

class PassCodeVC: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet var numButtons: [UILabel]!
    
    @IBOutlet weak var deleteBut: UIButton!
    
    @IBOutlet weak var dotsLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    var user: User!
    
    var passcode = [Int]()
    var enteredPasscode = ""
    var passLen = 0
    var supposedLen = 0
    var touchesSet: [Float32] = []
    var previousTouchEnd = NSDate()
    var currentTouchBeginning = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNums()
        prepareBackground()
        
        var attempts = 0
        
        switch supposedLen {
        case 4:
            attempts = user.num4Inputs.attempt
        case 5:
            attempts = user.num5Inputs.attempt
        case 6:
            attempts = user.num6Inputs.attempt
        default:
            break
        }
        
        statusLabel.text = "Entered \(attempts) times"
        headerLabel.text = "Enter \(supposedLen) number password"
        
        cancelButton.addTarget(nil, action: #selector(cancel), for: .touchUpInside)
    }
    
    func prepareNums(){
        for num in numButtons {
            num.layer.cornerRadius = 40
            num.layer.borderWidth = 1
            num.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    func prepareBackground() {
        self.view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    
    @IBAction func deleteButtonPressed (sender: UIButton) {
        self.deleteDot()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        resultLabel.text = ""
        
        for touch in touches {
            for i in 0...9 {
                if touch.view!.frame.origin == numButtons[i].frame.origin {
                    currentTouchBeginning = NSDate()
                    if !passcode.isEmpty  {
                        touchesSet.append(Float32(currentTouchBeginning.timeIntervalSince(previousTouchEnd as Date)))
                    } else {
                        touchesSet.append(Float32(0))
                    }
                    
                    passcode.append(i)
                    passLen += 1
                    self.addDot()
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        super.touchesEnded(touches, with: event)
        for touch in touches {
            for i in 0...9 {
                if touch.view!.frame.origin == numButtons[i].frame.origin {
                    previousTouchEnd = NSDate()
                    touchesSet.append(Float32(previousTouchEnd.timeIntervalSince(currentTouchBeginning as Date)))
                    
                    if passcode.count == supposedLen {
                        self.verifyPasscode()
                    }
                }
            }
        }
    }
    
    func addDot() {
        dotsLabel.text = (dotsLabel.text ?? "") + "\u{25cf}"
    }
    
    func deleteDot() {
        passLen = 0
        dotsLabel.text = ""
        self.touchesSet.removeAll()
        passcode.removeAll()
    }
    
    func verifyPasscode() {
        
        for num in self.numButtons {
            num.isUserInteractionEnabled = false
        }
        
        var password = ""
        var attempts = 0
        
        for i in 0...passLen - 1 {
            enteredPasscode = enteredPasscode + String(passcode[i])
        }
        
        switch passcode.count {
        case 4:
            password = user.passwords[0]
            attempts = user.num4Inputs.attempt
        case 5:
            password = user.passwords[1]
            attempts = user.num5Inputs.attempt
        case 6:
            password = user.passwords[2]
            attempts = user.num6Inputs.attempt
        default:
            analyzeAndShow(result: .error("Not enough characters"))
        }
        
        if enteredPasscode == password {
            analyzeAndShow(result: .success("You entered password \(attempts + 1) times!"))
        } else {
            analyzeAndShow(result: .error("Entered wrong passcode!"))
        }
        enteredPasscode = ""
    }
    
    func analyzeAndShow(result: AnalysisResult) {
        
        var attempt = 0
        
        switch result {
        case .success:
            
            resultLabel.text = "Right password"
            resultLabel.textColor = UIColor.green
            
            switch supposedLen {
            case 4:
                user.num4Inputs.userAttempts.append(touchesSet)
                user.num4Inputs.attempt += 1
                attempt = user.num4Inputs.attempt
            case 5:
                user.num5Inputs.userAttempts.append(touchesSet)
                user.num5Inputs.attempt += 1
                attempt = user.num5Inputs.attempt
            case 6:
                user.num6Inputs.userAttempts.append(touchesSet)
                user.num6Inputs.attempt += 1
                attempt = user.num6Inputs.attempt
            default:
                break
            }
            
            for attempts in user.num4Inputs.userAttempts {
                for time in attempts {
                    print(time)
                }
            }
            
            DataModel.dataModel.save()
            
            statusLabel.text = "Entered \(attempt) times"
            
            break
        case .error:
            enteredPasscode = ""
            resultLabel.text = "Wrong password"
            resultLabel.textColor = UIColor.red
        }
        
        deleteDot()
        
        for num in self.numButtons {
            num.isUserInteractionEnabled = true
        }
    }
    
    func makeTouchesSet(touches: [UITouch]) -> [Float32] {
        var set = [Float32]()
        
        set.append(Float32(0))
        
        for i in 1...(touches.count - 1) {
            set.append(Float32(touches[i].timestamp - touches[i - 1].timestamp))
        }
        
        return set
    }
    
    func ok(controller: UIAlertController) {
        self.deleteDot()
        controller.dismiss(animated: true, completion: {})
    }
    
    func setHeader(text: String) {
        headerLabel.text = text
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
