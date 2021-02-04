//
//  DeviceCellViewModel.swift
//  MyHome
//
//  Created by Salmen NOUIR on 01/02/2021.
//

import UIKit

class DeviceCellViewModel {
    var id: Int?
    var name: String
    var isON: Bool = false
    var value: String
    var image: UIImage?
    var type: ObjectType?
    
    init(_ connectedObj: ConnectedObject) {
        self.id = connectedObj.id.value
        self.name = connectedObj.deviceName ?? ""
        var stringValue = ""
        type = connectedObj.productType
        switch connectedObj.productType {
        case .light:
            self.image = Ressources.Images.lightIc
            if let light = connectedObj as? Light {
                self.isON = (light.mode == .on)
                stringValue = Ressources.Strings.lightValue
                if let intensity = light.intensity.value {
                    stringValue += ": \(intensity)"
                }
            }
        case .heater:
            self.image = Ressources.Images.heaterIc
            if let heater = connectedObj as? Heater {
                self.isON = (heater.mode == .on)
                if let temp = heater.temperature.value {
                    stringValue = String(format: Ressources.Strings.heaterValue, temp)
                }
            }
        case .rollerShutter:
            self.image = Ressources.Images.rollerShutterIc
            if let roller = connectedObj as? RollerShutter {
                self.isON = true
                stringValue = Ressources.Strings.rollerValue
                if let position = roller.position.value {
                    stringValue += ": \(position)"
                }
            }
        default:
            break
        }
        self.value = stringValue
    }
}
