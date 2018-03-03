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
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperimentCell", for: indexPath) as! ExperimentCell
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "4 character password"
        case 1:
            cell.titleLabel.text = "5 character password"
        case 2:
            cell.titleLabel.text = "6 character password"
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            presentPassCodeVC(requiredLen: 4)
        case 1:
            presentPassCodeVC(requiredLen: 5)
        case 2:
            presentPassCodeVC(requiredLen: 6)
        default:
            break
        }
    }
    
    func presentPassCodeVC(requiredLen: Int) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PassCode") as! PassCodeVC
        controller.supposedLen = requiredLen
        controller.user = user
        controller.modalTransitionStyle = .coverVertical
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
    }
}
