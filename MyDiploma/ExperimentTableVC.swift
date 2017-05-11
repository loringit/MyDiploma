//
//  ExperimentTableVC.swift
//  MyDiploma
//
//  Created by Булат Якупов on 11.05.17.
//  Copyright © 2017 Булат Якупов. All rights reserved.
//

import Foundation
import UIKit

class ExperimentCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

class ExperimnetTableVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(RegistrationVC.checkRows))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistartionCell", for: indexPath) as! RegistrationCell
        
        switch indexPath.row {
        case 0:
            cell.textField.placeholder = "Login"
        case 1:
            cell.textField.placeholder = "4 character password"
        case 2:
            cell.textField.placeholder = "5 character password"
        case 3:
            cell.textField.placeholder = "6 character password"
        default:
            break
        }
        
        return cell
    }
    
    func checkRows() {
        var login = ""
        var passwords = [String]()
        
        for i in 1...3 {
            let path = IndexPath(row: i, section: 0)
            
            let cell = tableView.cellForRow(at: path) as! RegistrationCell
            
            switch path.row {
            case 0:
                if let text = cell.textField.text {
                    login = text
                }
            case 1:
                if let text = cell.textField.text {
                    if text.characters.count == 4 {
                        passwords.append(text)
                    }
                }
            case 2:
                if let text = cell.textField.text {
                    if text.characters.count == 5 {
                        passwords.append(text)
                    }
                }
            case 3:
                if let text = cell.textField.text {
                    if text.characters.count == 6 {
                        passwords.append(text)
                    }
                }
            default:
                break
            }
        }
        
        if !login.isEmpty && passwords.count == 3 {
            let user = User(login: login, passwords: passwords)
            
            DataModel.dataModel.users.append(user)
            
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error!", message: "Check your fields! One of them is inappropriate!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
                (UIAlertAction) in
                self.ok(controller: alert)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func ok(controller: UIAlertController) {
        controller.dismiss(animated: true, completion: {})
    }
    
}
