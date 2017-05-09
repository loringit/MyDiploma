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

let myPasscode = 210995

enum AnalysisResult {
    case Success
    case WrongPassword
    case Infiltration
    case Error
}

class PassCodeVC: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet var dots: [UIView]!
    
    @IBOutlet var numButtons: [UILabel]!
    
    @IBOutlet weak var deleteBut: UIButton!
    
    var dataModel: DataModel!
    
    var passcode = [Int]()
    var enteredPasscode = 0
    var passLen = 0
    var firstTouch: CGFloat = 0
    var lastTouch: CGFloat = 0
    var touchesSet: [Float32] = []
    var previousTouchEnd = NSDate()
    var currentTouchBeginning = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareDots()
        prepareNums()
        prepareBackground()
    }
    
    func prepareDots(){
        for dot in dots {
            dot.layer.cornerRadius = 10
            dot.layer.borderWidth = 1
            dot.layer.borderColor = UIColor.white.cgColor
        }
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
        if passLen < 7 && passLen > 0 {
            dots[passLen - 1].backgroundColor = UIColor.white
        }
    }
    
    func deleteDot() {
        while passLen != 0 {
            dots[passLen - 1].backgroundColor = UIColor.clear
            passLen -= 1
        }
        
        self.touchesSet.removeAll()
        passcode.removeAll()
    }
    
    func verifyPasscode() {
        /*for num in numButtons {
            num.isUserInteractionEnabled = false
        }*/
        
        for i in 0...passLen - 1 {
            enteredPasscode = enteredPasscode + passcode[i] * Int(pow(Double(10), Double(passLen - 1 - i)))
        }
        
        if enteredPasscode == myPasscode {
            print("\(touchesSet), ")
            
            //deleteDot()
            print(dataModel.attempt)
            if dataModel.attempt < 100 {
                analyzeAndShow(result: .Success)
            } else {
                
                if dataModel.attempt == 100 {

                    analyzeAndShow(result: .Success)
                    
                    let parameters: Parameters = [
                        "trainingSet" : dataModel.userAttempts
                    ]
                    
                    print(dataModel.userAttempts.last!)
                    
                    Alamofire.request("http://loringit.pythonanywhere.com/train", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                            print(json["result"])
                        case .failure(let error):
                            print(error)
                        }
                    }
                } else {
             
                    let parameters: Parameters = [
                        "dataSet" : touchesSet
                    ]
                
                    Alamofire.request("http://loringit.pythonanywhere.com/check", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                            print(response)
                            switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                            if json["result"] == "true" {
                                self.analyzeAndShow(result: .Success)
                            } else {
                                self.analyzeAndShow(result: .Infiltration)
                            }
                        case .failure(let error):
                            self.analyzeAndShow(result: .Error)
                            print(error)
                        }
                    }
                }
            }
        } else {
            analyzeAndShow(result: .WrongPassword)
        }
        enteredPasscode = 0
    }
    
    func prepareAndShowAlertController(alertConfig: AnalysisResult, alertController alert: UIAlertController) {
        switch alertConfig {
        case .Success:
            alert.title = "Complete!"
            alert.message = "Entered right passcode!"
            break
        case .WrongPassword:
            alert.title = "Error!"
            alert.message = "Entered wrong passcode! Please check enter again."
            break
        case .Infiltration:
            alert.title = "Error!"
            alert.message = "Passcode have been entered by wrong person!"
            break
        case .Error:
            alert.title = "Error!"
            alert.message = "Something is wrong with server!"
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
        case .Success:
            dataModel.userAttempts.append(touchesSet)
            dataModel.saveTouches()
            dataModel.attempt += 1
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
