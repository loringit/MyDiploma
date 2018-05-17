//
//  LoginVC.swift
//  MyDiploma
//
//  Created by Булат Якупов on 09.05.17.
//  Copyright © 2017 Булат Якупов. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Enter button configuration
        enterButton.isEnabled = false
        enterButton.rx.tap.bind(to: viewModel.enter).disposed(by: disposeBag)
        viewModel.canEnter.asObservable().bind(to: enterButton.rx.isEnabled).disposed(by: disposeBag)
        
        // MARK: - Login field configuration
        loginTF.returnKeyType = .done
        loginTF.delegate = self
        loginTF.rx.text.bind(to: viewModel.text).disposed(by: disposeBag)
        
        viewModel.enterResult.drive(onNext: { [unowned self] user in
            if let user = user {
                self.navigationController?.pushViewController(ExperimnetTableVC.instance(for: user), animated: true)
            } else {
                let alert = UIAlertController(title: "Error!", message: "Couldn't find user with such login!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
                    (UIAlertAction) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        viewModel.enter.onNext(())
        
        return true
    }
}
