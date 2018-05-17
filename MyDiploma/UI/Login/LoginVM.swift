//
//  LoginVM.swift
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

class LoginViewModel {
    
    let text = PublishSubject<String?>()
    let enter = PublishSubject<Void>()
    
    var canEnter: Driver<Bool>
    var enterResult: Driver<User?>
    
    init() {
        canEnter = text.map{ text -> Bool in
            return text != nil && text != ""
        }.asDriver(onErrorDriveWith: Driver.empty())
        
        enterResult = enter.withLatestFrom(text).map { text in
            let realm = try! Realm()
            
            return realm.object(ofType: User.self, forPrimaryKey: text)
        }.asDriver(onErrorDriveWith: Driver.empty())
    }
}
