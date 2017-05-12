//
//  LoginVC.swift
//  MyDiploma
//
//  Created by Булат Якупов on 09.05.17.
//  Copyright © 2017 Булат Якупов. All rights reserved.
//

import Foundation
import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTF.returnKeyType = .done
        loginTF.delegate = self
        
        enterButton.isEnabled = false
        enterButton.addTarget(self, action: #selector(LoginVC.checkAndProceed), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.textDidChanged(notification:)), name: .UITextFieldTextDidChange, object: loginTF)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        checkAndProceed()
        
        return true
    }
    
    func textDidChanged(notification: NSNotification) {
        if let text = loginTF.text, text != "" {
            enterButton.isEnabled = true
        } else {
            enterButton.isEnabled = false
        }
    }
    
    func ok(controller: UIAlertController) {
        controller.dismiss(animated: true, completion: {})
    }
    
    func checkAndProceed() {
        if let login = loginTF.text {
            let user = DataModel.dataModel.getUser(with: login)
            if let usr = user {
                let experimentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExperimentsVC") as! ExperimnetTableVC
                experimentVC.user = usr
                navigationController?.pushViewController(experimentVC, animated: true)
            } else {
                let alert = UIAlertController(title: "Error!", message: "Couldn't find user with such login!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
                    (UIAlertAction) in
                    self.ok(controller: alert)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
