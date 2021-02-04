//
//  UserRepository.swift
//  MyHome
//
//  Created by Salmen NOUIR on 04/02/2021.
//

import Foundation


protocol UserRepository {
    func getUser(completion: ((User?, NetworkError?)->Void)?)
    func updateUserInfo(_ type: UserInfo, value: String)
    func updateAddress(_ newAddress: Address)
}
