//
//  ExperimentVM.swift
//  MyDiploma
//
//  Created by Булат Якупов on 14.05.2018.
//  Copyright © 2018 Булат Якупов. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ExperimentViewModel {
    
    let cellWasTapped = PublishSubject<IndexPath>()
    
    var cells: Driver<[Int]>
    var presentWithInfo: Driver<(supposedLen: Int, user: User)?>
    
    init(user: User) {
        
        var passwordLenghts = [Int]()
        
        for info in user.passwordInfos {
            passwordLenghts.append(info.password.count)
        }
        
        cells = Driver.just(passwordLenghts)
        
        presentWithInfo = cellWasTapped.map{ indexPath -> (supposedLen: Int, user: User)? in
            if indexPath.row < passwordLenghts.count {
                return (supposedLen: passwordLenghts[indexPath.row], user: user)
            } else {
                return nil
            }
        }.asDriver(onErrorDriveWith: Driver.empty())
    }
}
