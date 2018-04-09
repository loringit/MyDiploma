//
//  RegistrationVC.swift
//  MyDiploma
//
//  Created by Булат Якупов on 09.05.17.
//  Copyright © 2017 Булат Якупов. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift

class RegistrationCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
}

class RegistrationVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(checkRows))
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
            
        default:
            cell.textField.placeholder = "\(3 + indexPath.row) character password"
        }
        
        return cell
    }
    
    @objc func checkRows() {
        var login = ""
        var passwords = [String]()
        
        for i in 0...3 {
            let path = IndexPath(row: i, section: 0)
            
            let cell = tableView.cellForRow(at: path) as! RegistrationCell
            
            switch i {
            case 0:
                if let text = cell.textField.text {
                    login = text
                    let realm = try! Realm()
                    
                    if realm.object(ofType: User.self, forPrimaryKey: login) != nil {
                        login = ""
                        presentAlert(with: "Error!", and: "Check your fields! At least one of them is inappropriate!")
                        return
                    }
                }
                
            default:
                if let text = cell.textField.text {
                    if text.count == (3 + i) {
                        passwords.append(text)
                    }
                }
            }
        }
        
        if !login.isEmpty && passwords.count == 3 {
            let realmUser = User()
            realmUser.login = login
            
            for password in passwords {
                let newPasswordInfo = PasswordInfo()
                newPasswordInfo.password = password
                realmUser.passwordInfos.append(newPasswordInfo)
            }
            
            let realm = try! Realm()
            
            try! realm.write {
                realm.add(realmUser, update: true)
            }
            
            let _ = navigationController?.popViewController(animated: true)
        } else {
            presentAlert(with: "Error!", and: "Check your fields! At least one of them is inappropriate!")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
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
