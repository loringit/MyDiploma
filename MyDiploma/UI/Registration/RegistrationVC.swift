//
//  RegistrationVC.swift
//  MyDiploma
//
//  Created by Булат Якупов on 09.05.17.
//  Copyright © 2017 Булат Якупов. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class RegistrationCell: UITableViewCell {
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var textField: UITextField!
}

class RegistrationVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = RegistrationViewModel()
    let disposeBag = DisposeBag()
    
    var cells = [RegistrationViewModel.CellType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(checkRows))
        
        viewModel.cells.drive(onNext: { [unowned self] in
            self.cells = $0
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.saveResult.drive(onNext: { [unowned self] isSucessful in
            if isSucessful {
                let _ = self.navigationController?.popViewController(animated: true)
            } else {
                self.presentAlert(with: "Error!", and: "Check your fields! At least one of them is inappropriate!")
            }
        }).disposed(by: disposeBag)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistartionCell", for: indexPath) as! RegistrationCell
        cell.disposeBag = DisposeBag()
            
        switch cells[indexPath.row] {
        case .login:
            cell.textField.placeholder = "Login"
            cell.textField.rx.text.bind(to: viewModel.login).disposed(by: cell.disposeBag)
            
        case .password(let length):
            cell.textField.placeholder = "\(length) character password"
            cell.textField.rx.text.subscribe(onNext: { [unowned self] in
                self.viewModel.passwords.value[length] = $0
            }).disposed(by: cell.disposeBag)
        }
        
        return cell
    }
    
    @objc func checkRows() {
        viewModel.save.onNext(())
    }
    
    func presentAlert(with title: String, and subtitle: String) {
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { [unowned self] (UIAlertAction) in
            self.dismiss(animated: true, completion: {})
        })
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
