//
//  User.swift
//  MyHome
//
//  Created by Salmen NOUIR on 03/02/2021.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    dynamic var birthdate = RealmOptional<Int64>()
    @objc dynamic var address: Address?
    
    /**
     This function initialize the user's properties from JSON
     - Parameter dictionary: the JSON object as a Dictionary
     */
    func setProperties(fromDictionary dictionary: [String:Any]){
        self.firstName = dictionary["firstName"] as? String
        self.lastName = dictionary["lastName"] as? String
        self.birthdate.value = dictionary["birthDate"] as? Int64
        if let addressDict = dictionary["address"] as? [String: Any] {
            let userAddress = Address()
            userAddress.setProperties(fromDictionary: addressDict)
            self.address = userAddress
        }
    }
    
    ///This function return Date object for the user's birthdate
    func getBirthDate() -> Date? {
        if let seconds = birthdate.value {
            let date = Date(timeIntervalSince1970: Double(seconds))
            return date
        } else {
            return nil
        }
    }
}
