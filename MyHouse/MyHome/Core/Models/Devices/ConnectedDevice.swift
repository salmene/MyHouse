//
//  ConnectedDevice.swift
//  MyHome
//
//  Created by Salmen NOUIR on 31/01/2021.
//

import Foundation
import RealmSwift

enum ObjectType: String {
    case heater = "Heater"
    case light = "Light"
    case rollerShutter = "RollerShutter"
}

enum ObjectMode: String {
    case on = "ON"
    case off = "OFF"
}

class ConnectedObject : Object {

    dynamic var id = RealmOptional<Int>()
    @objc dynamic var deviceName : String?
    @objc dynamic var type: String?
    
    var productType: ObjectType? {
        get {
            if type != nil {
                return ObjectType(rawValue: type!)
            } else {
                return nil
            }
        }
        set {
            type = newValue?.rawValue
        }
    }
    
    /**
     This function initialize the device's properties from JSON
     - Parameter dictionary: the JSON object as a Dictionary
     */
    func setProperties(fromDictionary dictionary: [String:Any]){
        self.id.value = dictionary["id"] as? Int
        self.deviceName = dictionary["deviceName"] as? String
        if let type = dictionary["productType"] as? String {
            self.productType = ObjectType(rawValue: type)
        }
    }
}
