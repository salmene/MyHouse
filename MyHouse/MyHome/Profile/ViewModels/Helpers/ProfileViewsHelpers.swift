//
//  ProfileViewsHelpers.swift
//  MyHome
//
//  Created by Salmen NOUIR on 04/02/2021.
//

import Foundation

enum UserInfo {
    case firstName
    case lastName
    case birthDate
    case address
    
    func getTitle() -> String {
        switch self {
        case .firstName:
            return Ressources.Strings.firstNameTitle
        case .lastName:
            return Ressources.Strings.lastNameTitle
        case .birthDate:
            return Ressources.Strings.birthDateTitle
        case .address:
            return Ressources.Strings.addressTitle
        }
    }
}

enum AddressCompoenent {
    case streetCode
    case street
    case city
    case postalCode
    case country
    
    func getTitle() -> String {
        switch self {
        case .streetCode:
            return Ressources.Strings.streetCodeTitle
        case .street:
            return Ressources.Strings.streetTitle
        case .city:
            return Ressources.Strings.cityTitle
        case .postalCode:
            return Ressources.Strings.postalCodeTitle
        case .country:
            return Ressources.Strings.countryTitle
        }
    }
}

