//
//  Heater.swift
//  MyHome
//
//  Created by Salmen NOUIR on 31/01/2021.
//

import Foundation
import RealmSwift

class Heater : ConnectedObject {
    
    @objc dynamic var modeValue: String?
    dynamic var temperature = RealmOptional<Float>()
    
    var mode : ObjectMode? {
        get {
            if modeValue != nil {
                return ObjectMode(rawValue: modeValue!)
            } else {
                return  nil
            }
        }
        set {
            modeValue = newValue?.rawValue
        }
    }

    /**
     This function initialize the heater's properties from JSON
     - Parameter dictionary: the JSON object as a Dictionary
     */
    override func setProperties(fromDictionary dictionary: [String:Any]) {
        super.setProperties(fromDictionary: dictionary)
        if let modeString = dictionary["mode"] as? String {
            mode = ObjectMode(rawValue: modeString)
        }
        temperature.value = dictionary["temperature"] as? Float
    }
}
