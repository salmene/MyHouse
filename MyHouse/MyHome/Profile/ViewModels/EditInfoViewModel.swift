//
//  EditInfoViewModel.swift
//  MyHome
//
//  Created by Salmen NOUIR on 03/02/2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol EditInfoViewModel {
    var infoType: UserInfo {get}
    var infoValue: BehaviorRelay<String> {get}
    func updateUser()
    func getDate() -> Date?
}

final class DefaultEditInfoViewModel: EditInfoViewModel {
    
    var infoType: UserInfo
    var infoValue: BehaviorRelay<String> = BehaviorRelay(value: "")
    var dataManager: UserRepository
    
    init(_ manager: UserRepository, type: UserInfo, oldValue: String) {
        infoType = type
        dataManager = manager
        infoValue.accept(oldValue)
    }
    
    /**
     This function return a date object if the editing info is birthdate
     */
    func getDate() -> Date? {
        guard infoType == .birthDate else {
            return nil
        }
        return DateHelper.getDateFromString(infoValue.value)
    }
    
    /**
     This function updates the user informations on the repossitory
     */
    func updateUser() {
        dataManager.updateUserInfo(infoType, value: infoValue.value)
    }
}
