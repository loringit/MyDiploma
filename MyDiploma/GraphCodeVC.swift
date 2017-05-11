//
//  GraphCodeVC.swift
//  MyDiploma
//
//  Created by Булат Якупов on 09.05.17.
//  Copyright © 2017 Булат Якупов. All rights reserved.
//

import Foundation
import UIKit

class GraphCodeVC: UIViewControlle, GraphCodeViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var graphCodeView: GraphCodeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphCodeView.delegate = self
    }
    
    func graphCodeView(touchTime: Date, andDot: DotPosition) {
        
    }
    
    func graphCodeView(touchEndedInTime: Date, andDot: DotPosition?)
}
