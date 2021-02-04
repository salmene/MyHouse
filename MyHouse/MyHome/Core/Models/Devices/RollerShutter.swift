//
//  RollerShutter.swift
//  MyHome
//
//  Created by Salmen NOUIR on 31/01/2021.
//

import Foundation
import RealmSwift

class RollerShutter : ConnectedObject {

    dynamic var position = RealmOptional<Int>()

    /**
     This function initialize the roller shutter's properties from JSON
     - Parameter dictionary: the JSON object as a Dictionary
     */
    override func setProperties(fromDictionary dictionary: [String:Any]) {
        super.setProperties(fromDictionary: dictionary)
        position.value = dictionary["position"] as? Int
    }
}
