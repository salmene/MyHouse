//
//  Light.swift
//  MyHome
//
//  Created by Salmen NOUIR on 31/01/2021.
//

import Foundation
import RealmSwift

class Light : ConnectedObject {

    @objc dynamic var modeValue: String?
    dynamic var intensity = RealmOptional<Int>()
    
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
     This function initialize the light's properties from JSON
     - Parameter dictionary: the JSON object as a Dictionary
     */
    override func setProperties(fromDictionary dictionary: [String:Any]) {
        super.setProperties(fromDictionary: dictionary)
        if let modeString = dictionary["mode"] as? String {
            mode = ObjectMode(rawValue: modeString)
        }
        intensity.value = dictionary["intensity"] as? Int
    }
}
