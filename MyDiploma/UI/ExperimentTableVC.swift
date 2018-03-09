//
//  ExperimentTableVC.swift
//  MyDiploma
//
//  Created by Булат Якупов on 11.05.17.
//  Copyright © 2017 Булат Якупов. All rights reserved.
//

import Foundation
import UIKit

class ExperimnetTableVC: UITableViewController {
    
    var user: User!
    
    static func instance(for user: User) -> ExperimnetTableVC {
        let experimentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExperimentsVC") as! ExperimnetTableVC
        experimentVC.user = user
        return experimentVC
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperimentCell", for: indexPath)
        
        cell.textLabel?.text = "\(4 + indexPath.row) character password"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presentPassCodeVC(requiredLen: indexPath.row  + 4)
    }
    
    func presentPassCodeVC(requiredLen: Int) {
        let controller = PassCodeVC.instance(with: requiredLen, and: user)
        controller.modalTransitionStyle = .coverVertical
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
    }
}
