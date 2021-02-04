//
//  ProfileViewModel.swift
//  MyHome
//
//  Created by Salmen NOUIR on 03/02/2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol ProfileViewModel {
    func getUser()
    var error: PublishSubject<NetworkError> {get}
    var dataSource: BehaviorRelay<[(UserInfo, String?)]> {get}
    var addressData: [AddressCompoenent: String] {get}
}

final class DefaultProfileViewModel: ProfileViewModel {
    
    var error: PublishSubject<NetworkError> = PublishSubject()
    var dataSource: BehaviorRelay<[(UserInfo, String?)]> = BehaviorRelay(value: [])
    var addressData: [AddressCompoenent: String] = [:]
    var dataManager: UserRepository
    
    private var user: User?
    
    init(_ manager: UserRepository) {
        self.dataManager = manager
    }
    
    /**
     This function get user from repository and refresh dataSource
     */
    func getUser() {
        dataManager.getUser {[weak self] (userModel, error) in
            guard let self = self else { return }
            guard let userModel = userModel, error == nil else {
                if let error = error {
                    self.error.onNext(error)
                } else {
                    self.error.onNext(NetworkError.defaultError)
                }
                return
            }
            self.user = userModel
            self.genretaDataSource(userModel)
            self.generateAddressData(userModel)
        }
    }
    
    /**
     This function refresh the address data
     - Parameter userModel: the user that address will be displayed
     */
    private func generateAddressData(_ userModel: User) {
        addressData[.streetCode] = userModel.address?.streetCode ?? ""
        addressData[.street] = userModel.address?.street ?? ""
        addressData[.city] = userModel.address?.city ?? ""
        addressData[.postalCode] = (userModel.address?.postalCode.value != nil) ? "\(userModel.address!.postalCode.value!)" : ""
        addressData[.country] = userModel.address?.country ?? ""
    }
    
    /**
     This function refresh the view' data
     - Parameter userModel: the user that his informations will be displayed
     */
    private func genretaDataSource(_ userModel: User) {
        var newDataSource = [(UserInfo, String?)]()
        newDataSource.append((UserInfo.firstName, userModel.firstName))
        newDataSource.append((UserInfo.lastName, userModel.lastName))
        if let date = userModel.getBirthDate() {
            newDataSource.append((UserInfo.birthDate, DateHelper.getDateString(date)))
        } else {
            newDataSource.append((UserInfo.birthDate, ""))
        }
        var addressString = ""
        if let streetCode = userModel.address?.streetCode { addressString += streetCode + " "}
        if let street = userModel.address?.street { addressString += street + " "}
        if let city = userModel.address?.city { addressString += city + ", "}
        if let postalCode = userModel.address?.postalCode.value { addressString += "\(postalCode)"}
        if let country = userModel.address?.country { addressString += ", " + country }
        newDataSource.append((UserInfo.address, addressString))
        self.dataSource.accept(newDataSource)
    }
    
}

