//
//  ExperimentTableVC.swift
//  MyDiploma
//
//  Created by Булат Якупов on 11.05.17.
//  Copyright © 2017 Булат Якупов. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ExperimnetTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ExperimentViewModel!
    var cells = [Int]()
    private let disposeBag = DisposeBag()
        
    static func instance(for user: User) -> ExperimnetTableVC {
        let experimentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExperimentsVC") as! ExperimnetTableVC
        experimentVC.viewModel = ExperimentViewModel.init(user: user)
        return experimentVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - TableView configuration
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rx.itemSelected.bind(to: viewModel.cellWasTapped).disposed(by: disposeBag)
        
        // MARK: - ViewModel handling
        
        viewModel.cells.drive(onNext:{ [unowned self] in
            self.cells = $0
        }).disposed(by: disposeBag)
        
        viewModel.presentWithInfo.drive(onNext: { [unowned self] info in
            if let info = info {
                self.presentPassCodeVC(requiredLen: info.supposedLen, and: info.user)
            } else {
                self.showError()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperimentCell", for: indexPath)
        
        cell.textLabel?.text = "\(cells[indexPath.row]) character password"
        
        return cell
    }
    
    func presentPassCodeVC(requiredLen: Int, and user: User) {
        let controller = PassCodeVC.instance(with: requiredLen, and: user)
        controller.modalTransitionStyle = .coverVertical
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func showError() {
        let alert = UIAlertController(title: "Error!", message: "Couldn't find required experiment", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { [unowned self] (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
