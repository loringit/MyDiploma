//
//  PassCodeVC.swift
//  MyDiploma
//
//  Created by Булат Якупов on 04.10.16.
//  Copyright © 2016 Булат Якупов. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

enum AnalysisResult {
    case success(String)
    case wrongPassword
}

class PassCodeVC: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet var numButtons: [UILabel]!
    
    @IBOutlet weak var deleteBut: UIButton!
    
    @IBOutlet weak var dotsLabel: UILabel!
    
    var user: User!
    
    var passcode = [Int]()
    var enteredPasscode = ""
    var passLen = 0
    var firstTouch: CGFloat = 0
    var lastTouch: CGFloat = 0
    var touchesSet: [Float32] = []
    var previousTouchEnd = NSDate()
    var currentTouchBeginning = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNums()
        prepareBackground()
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
        for touch in touches {
            for i in 0...9 {
                if touch.view!.frame.origin == numButtons[i].frame.origin {
                    currentTouchBeginning = NSDate()
                    if !passcode.isEmpty  {
                        touchesSet.append(Float32(currentTouchBeginning.timeIntervalSince(previousTouchEnd as Date)))
                    }
                    
                    passcode.append(i)
                    passLen += 1
                }
            }
            
            self.addDot()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        super.touchesEnded(touches, with: event)
        for touch in touches {
            for i in 0...9 {
                if touch.view!.frame.origin == numButtons[i].frame.origin {
                    previousTouchEnd = NSDate()
                    touchesSet.append(Float32(previousTouchEnd.timeIntervalSince(currentTouchBeginning as Date)))
                    
                    if passcode.count == 6 {
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
        dotsLabel.text = ""
        self.touchesSet.removeAll()
        passcode.removeAll()
    }
    
    func verifyPasscode() {
        
        var password = ""
        
        for i in 0...passLen - 1 {
            enteredPasscode = enteredPasscode + String(passcode[i] * Int(pow(Double(10), Double(passLen - 1 - i))))
        }
        
        switch enteredPasscode.characters.count {
        case 4:
            password = user.passwords[0]
        case 5:
            password = user.passwords[1]
        case 6:
            password = user.passwords[2]
        default:
            break
        }
        
        if enteredPasscode == password {
            print("\(touchesSet)")
            print(user.numInputs.attempt)
            
            analyzeAndShow(result: .success("You entered password \(user.numInputs.attempt) times!"))
        } else {
            analyzeAndShow(result: .wrongPassword)
        }
        enteredPasscode = ""
    }
    
    func prepareAndShowAlertController(alertConfig: AnalysisResult, alertController alert: UIAlertController) {
        switch alertConfig {
        case .success(let str):
            alert.title = "Complete!"
            alert.message = str
            break
        case .wrongPassword:
            alert.title = "Error!"
            alert.message = "Entered wrong passcode! Please check enter again."
            break
        }
        
        self.present(alert, animated: true, completion: {
            _ in
            for num in self.numButtons {
                num.isUserInteractionEnabled = true
            }
            self.touchesSet.removeAll()
        })
    }
    
    func analyzeAndShow(result: AnalysisResult) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            (UIAlertAction) in
            self.ok(controller: alert)
        }))
        prepareAndShowAlertController(alertConfig: result, alertController: alert)
        
        switch result {
        case .success:
            user.numInputs.userAttempts.append(touchesSet)
            user.numInputs.saveTouches()
            user.numInputs.attempt += 1
            break
        default:
            break
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
        controller.dismiss(animated: true, completion: {})
        self.deleteDot()
    }
    
    func setHeader(text: String) {
        headerLabel.text = text
    }
}
