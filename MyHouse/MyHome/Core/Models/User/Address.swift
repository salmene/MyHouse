//
//  Address.swift
//  MyHome
//
//  Created by Salmen NOUIR on 03/02/2021.
//

import Foundation
import RealmSwift

class Address: Object {
    
    @objc dynamic var city: String?
    @objc dynamic var country: String?
    @objc dynamic var street: String?
    @objc dynamic var streetCode: String?
    dynamic var postalCode = RealmOptional<Int>()
    
    /**
     This function initialize the address's properties from JSON
     - Parameter dictionary: the JSON object as a Dictionary
     */
    func setProperties(fromDictionary dictionary: [String:Any]){
        self.postalCode.value = dictionary["postalCode"] as? Int
        self.city = dictionary["city"] as? String
        self.country = dictionary["country"] as? String
        self.streetCode = dictionary["streetCode"] as? String
        self.street = dictionary["street"] as? String
    }
}
