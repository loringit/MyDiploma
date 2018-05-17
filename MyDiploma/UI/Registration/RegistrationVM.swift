//
//  RegistrationVM.swift
//  MyDiploma
//
//  Created by Булат Якупов on 14.05.2018.
//  Copyright © 2018 Булат Якупов. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import Realm

class RegistrationViewModel {
    
    enum CellType {
        case login
        case password(Int)
    }
    
    let login = Variable<String?>(nil)
    let passwords = Variable<[Int : String?]>([Int : String?]())
    let save = PublishSubject<Void>()
    
    var cells: Driver<[CellType]>
    var saveResult: Driver<Bool>
    
    init() {
        let passwordLenghts = Variable<[Int]>([4, 5, 6])
        
        cells = passwordLenghts.asDriver().map({ lengths -> [CellType] in
            var items: [CellType] = [.login]
            
            for length in lengths {
                items.append(.password(length))
            }
            
            return items
        })
        
        let currentRows = Observable.combineLatest(login.asObservable(), passwords.asObservable()).map{(login: $0, passwords: $1)}
        
        let checkResult = save.withLatestFrom(currentRows).map({ (login, passwords) -> Bool in

            if passwords.count == 0 {
                return false
            }
            
            if login == nil || login == "" {
                return false
            }
            
            for length in passwordLenghts.value {
                if let password = passwords[length] {
                    if password?.count != length  {
                        return false
                    }
                } else {
                    return false
                }
            }
            
            return true
        })
        
        saveResult = checkResult.withLatestFrom(currentRows) {($0, $1)}.map({ (isOk, info) -> Bool in
            
            if isOk {
                let realmUser = User()
                realmUser.login = info.login ?? ""

                for length in passwordLenghts.value {
                    if let password = info.passwords[length] {
                        let newPasswordInfo = PasswordInfo()
                        newPasswordInfo.password = password ?? ""
                        realmUser.passwordInfos.append(newPasswordInfo)
                    }
                }

                let realm = try! Realm()

                try! realm.write {
                    realm.add(realmUser, update: true)
                }
                
                return true
            } else {
                return false
            }
        }).asDriver(onErrorDriveWith: Driver.empty())
    }
}
