//
//  PassCodeVC.swift
//  MyDiploma
//
//  Created by Булат Якупов on 04.10.16.
//  Copyright © 2016 Булат Якупов. All rights reserved.
//

import Foundation
import UIKit

class PassCodeVC: UIViewController, PassCodeVMDelegate {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet var numButtons: [UILabel]!
    
    @IBOutlet weak var deleteBut: UIButton!
    
    @IBOutlet weak var dotsLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    private var loader: UIView?
    
    private var viewModel: PassCodeVM!
    
    var previousTouchEnd: Date?
    var currentTouchBeginning: Date?
    
    static func instance(with supposedLen: Int, and user: User) -> PassCodeVC {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PassCode") as! PassCodeVC
        controller.viewModel = PassCodeVM(with: supposedLen, for: user)
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        prepareNums()
        prepareBackground()
        
        headerLabel.text = "Enter \(viewModel.supposedLen) number password"
        
        cancelButton.addTarget(nil, action: #selector(cancel), for: .touchUpInside)
    }
    
    func prepareNums(){
        numButtons.forEach {
            $0.layer.cornerRadius = 40
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
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
        viewModel.clearInput()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        resultLabel.text = ""
        
        for touch in touches {
            for i in 0...9 {
                if touch.view!.frame.origin == numButtons[i].frame.origin {
                    currentTouchBeginning = Date()
                    
                    if previousTouchEnd != nil {
                        previousTouchEnd = currentTouchBeginning
                    }
                    
                    viewModel.add(touchTime: Float32(currentTouchBeginning?.timeIntervalSince(previousTouchEnd ?? Date()) ?? TimeInterval(0)))
                    viewModel.add(num: i)
                    
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
                    previousTouchEnd = Date()
                    viewModel.add(touchTime: Float32(previousTouchEnd?.timeIntervalSince(currentTouchBeginning ?? Date()) ?? TimeInterval(0)))
                }
            }
        }
    }
    
    func addDot() {
        dotsLabel.text = (dotsLabel.text ?? "") + "\u{25cf}"
    }
    
    func deleteDot() {
        dotsLabel.text = ""
        viewModel.clearInput()
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
    
    // MARK: PassCodeVMDelegate
    
    func update(for attempts: Int) {
        statusLabel.text = "Entered \(viewModel.attempts) times"
    }
    
    func showLoader() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        loader = blurEffectView
    }
    
    func show(_ result: AnalysisResult) {
        loader?.removeFromSuperview()
        loader = nil
        
        switch result {
        case .success:
            resultLabel.text = "Right password"
            resultLabel.textColor = UIColor.green
            
            break
        case .error:
            resultLabel.text = "Wrong password"
            resultLabel.textColor = UIColor.red
        }
        
        deleteDot()
    }
}
