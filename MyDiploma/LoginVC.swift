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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTF.returnKeyType = .done
        loginTF.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let login = loginTF.text {
            let user = DataModel.dataModel.getUser(with: login)
            if let usr = user {
                
                let passcodeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PassCode") as! PassCodeVC
                passcodeVC.user = usr
                passcodeVC.modalPresentationStyle = .overFullScreen
                passcodeVC.modalTransitionStyle = .flipHorizontal
                
                navigationController?.present(passcodeVC, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error!", message: "Couldn't find user with such login!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
                    (UIAlertAction) in
                    self.ok(controller: alert)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        return true
    }
    
    func ok(controller: UIAlertController) {
        controller.dismiss(animated: true, completion: {})
    }
}
