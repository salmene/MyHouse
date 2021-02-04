//
//  UserRepositoryMock.swift
//  MyHomeTests
//
//  Created by Salmen NOUIR on 04/02/2021.
//

@testable import MyHome
import Foundation

class UserRepositoryMock: UserRepository {
    
    var user: User?
    
    init(_ user: User?) {
        self.user = user
    }
    
    func getUser(completion: ((User?, NetworkError?) -> Void)?) {
        completion?(user, nil)
    }
    
    func updateUserInfo(_ type: UserInfo, value: String) {
        switch type {
        case .firstName:
            self.user?.firstName = value
        case .lastName:
            self.user?.lastName = value
        case .birthDate:
            if let date = DateHelper.getDateFromString(value) {
                let seconds = Int64(date.timeIntervalSince1970)
                user?.birthdate.value = seconds
            }
        default:
            break
        }
    }
    
    func updateAddress(_ newAddress: Address) {
        user?.address = newAddress
    }
    
    
}
