//
//  EditAddressViewModel.swift
//  MyHome
//
//  Created by Salmen NOUIR on 03/02/2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol EditAddressViewModel {
    var streetCode: BehaviorRelay<String> {get}
    var street: BehaviorRelay<String> {get}
    var city: BehaviorRelay<String> {get}
    var postalCode: BehaviorRelay<String> {get}
    var country: BehaviorRelay<String> {get}
    func updateUser()
}

final class DefaultEditAddressViewModel: EditAddressViewModel {
    
    var streetCode: BehaviorRelay<String> = BehaviorRelay(value: "")
    var street: BehaviorRelay<String> = BehaviorRelay(value: "")
    var city: BehaviorRelay<String> = BehaviorRelay(value: "")
    var postalCode: BehaviorRelay<String> = BehaviorRelay(value: "")
    var country: BehaviorRelay<String> = BehaviorRelay(value: "")
    private var dataManager: UserRepository
    
    init(_ manager: UserRepository, addressData: [AddressCompoenent: String]) {
        streetCode.accept(addressData[.streetCode] ?? "")
        street.accept(addressData[.street] ?? "")
        city.accept(addressData[.city] ?? "")
        postalCode.accept(addressData[.postalCode] ?? "")
        country.accept(addressData[.country] ?? "")
        dataManager = manager
    }
    
    /**
     This function updates the user address on the repossitory
     */
    func updateUser() {
        let newAddress = Address()
        newAddress.streetCode = streetCode.value
        newAddress.street = street.value
        newAddress.city = city.value
        newAddress.postalCode.value = Int(postalCode.value)
        newAddress.country = country.value
        dataManager.updateAddress(newAddress)
    }
}
