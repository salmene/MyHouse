//
//  DevicesRepository.swift
//  MyHome
//
//  Created by Salmen NOUIR on 31/01/2021.
//

import Foundation
import RealmSwift

final class DefaultDevicesRepository: DevicesRepository {
    
    static let sharedInstance = DefaultDevicesRepository()
    private init() {}
    
    /**
     This function execute the completion closure with list of devices from database if they exist
     else it makes an url request and then return the that list. If any error occured the list object
     will be nil and the error will have a value
     - Parameter completion: Closure to be exucted on response received
    */
    func getDevices(completion: (([ConnectedObject]?, NetworkError?) -> Void)?) {
        let realm = try! Realm()
        let objects = realm.objects(ConnectedObject.self)
        if objects.count != 0 {
            var devicesList = [ConnectedObject]()
            for object in objects {
                guard let id = object.id.value else {
                    continue
                }
                switch object.productType {
                case .heater:
                    if let heater = realm.objects(Heater.self).filter("id = \(id)").first {
                        devicesList.append(heater)
                    }
                case .light:
                    if let light = realm.objects(Light.self).filter("id = \(id)").first {
                        devicesList.append(light)
                    }
                case .rollerShutter:
                    if let roller = realm.objects(RollerShutter.self).filter("id = \(id)").first {
                        devicesList.append(roller)
                    }
                default:
                    continue
                }
            }
            completion?(devicesList, nil)
            return
        } else {
            self.getDevicesFromServer { (devices, error) in
                if let error = error {
                    completion?(nil, error)
                } else if let devices = devices {
                    completion?(devices, nil)
                } else {
                    completion?(nil, NetworkError.defaultError)
                }
            }
        }
    }
    
    /**
     This function returns a device from database with its id and type
     - Parameters:
        - id: the device's id
        - type: the device's type
     - Returns: the device object if it exists else nil
     */
    func getDevice(with id: Int, type: ObjectType) -> ConnectedObject? {
        let realm = try! Realm()
        switch type {
        case .heater:
            let heater = realm.objects(Heater.self).filter("id = \(id)")
            return heater.first
        case .light:
            let light = realm.objects(Light.self).filter("id = \(id)")
            return light.first
        case .rollerShutter:
            let roller = realm.objects(RollerShutter.self).filter("id = \(id)")
            return roller.first
        }
    }
    
    /**
     This function updates a light device properties on the database
     - Parameters:
        - deviceID: id of the device to be updated
        - newValue: the new intensity's value to be setted
        - mode: the new mode (ON/OFF) to be setted
     */
    func updateLight(_ deviceID: Int, newValue: Int, mode: ObjectMode) {
        let realm = try! Realm()
        let light = realm.objects(Light.self).filter("id = \(deviceID)").first
        if let light = light {
            try! realm.write {
                light.intensity.value = newValue
                light.modeValue = mode.rawValue
            }
        }
    }
    
    /**
     This function updates a heater device properties on the database
     - Parameters:
        - deviceID: id of the device to be updated
        - newValue: the new temperature's value to be setted
        - mode: the new mode (ON/OFF) to be setted
     */
    func updateHeater(_ deviceID: Int, newValue: Float, mode: ObjectMode) {
        let realm = try! Realm()
        let heater = realm.objects(Heater.self).filter("id = \(deviceID)").first
        if let heater = heater {
            try! realm.write {
                heater.temperature.value = newValue
                heater.modeValue = mode.rawValue
            }
        }
    }
    
    /**
     This function updates a roller shutter position on the database
     - Parameters:
        - deviceID: id of the device to be updated
        - newPosition: the new position's value to be setted
     */
    func updateRoller(_ deviceID: Int, newPosition: Int) {
        let realm = try! Realm()
        let roller = realm.objects(RollerShutter.self).filter("id = \(deviceID)").first
        if let roller = roller {
            try! realm.write {
                roller.position.value = newPosition
            }
        }
    }
    
    /**
     This function deletes a device from database with its id and type
     - Parameters:
        - deviceID: the device's id
        - type: the device's type
     */
    func deleteDevice(_ deviceID: Int, type: ObjectType) {
        let realm = try! Realm()
        switch type {
        case .heater:
            let heaterToDelete = realm.objects(Heater.self).filter("id = \(deviceID)")
            try! realm.write {
                realm.delete(heaterToDelete)
            }
        case .light:
            let lightToDelete = realm.objects(Light.self).filter("id = \(deviceID)")
            try! realm.write {
                realm.delete(lightToDelete)
            }
        case .rollerShutter:
            let rollerToDelete = realm.objects(RollerShutter.self).filter("id = \(deviceID)")
            try! realm.write {
                realm.delete(rollerToDelete)
            }
        }
        let deviceToDelete = realm.objects(ConnectedObject.self).filter("id = \(deviceID)")
        try! realm.write {
            realm.delete(deviceToDelete)
        }
    }
    
    /**
     This function execute the completion closure with list of devices returned and parsed from an url request response.
     If any error occured the list object will be nil and the error will have a value
     - Parameter completion: Closure to be exucted on request response
    */
    private func getDevicesFromServer(_ completion: (([ConnectedObject]?, NetworkError?) -> Void)?) {
        guard let url = URL(string: Constants.baseURL) else {
            completion?(nil, NetworkError.defaultError)
            return
        }
        let reachability = try! Reachability()
        if reachability.connection == .unavailable {
            completion?(nil, NetworkError.noInternet)
            return
        }
        let task = URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
            guard let data = data, error == nil else {
                completion?(nil, NetworkError.defaultError)
                return
            }
            do {
                let responseDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                let devicesList = self?.parseSaveResponse(responseDictionary)
                completion?(devicesList, nil)
            } catch {
                completion?(nil, NetworkError.defaultError)
            }
        }
        task.resume()
    }
    
    /**
     This function parse a JSON and returns the list of devices
     - Parameter dictionary: the JSON object as a Dictionary
     - Returns: the parsed list of devices
     */
    private func parseSaveResponse(_ dictionary: [String: Any]) -> [ConnectedObject]? {
        var devicesList = [ConnectedObject]()
        if let devices = dictionary["devices"] as? [[String: Any]] {
            for device in devices {
                let object = ConnectedObject()
                object.setProperties(fromDictionary: device)
                guard let _ = object.id.value, let type = object.productType else {
                    continue
                }
                let realm = try! Realm()
                try! realm.write {
                    realm.add(object)
                }
                switch type {
                case .heater:
                    let heater = Heater()
                    heater.setProperties(fromDictionary: device)
                    try! realm.write {
                        realm.add(heater)
                    }
                    devicesList.append(heater)
                case .light:
                    let light = Light()
                    light.setProperties(fromDictionary: device)
                    try! realm.write {
                        realm.add(light)
                    }
                    devicesList.append(light)
                case .rollerShutter:
                    let roller = RollerShutter()
                    roller.setProperties(fromDictionary: device)
                    try! realm.write {
                        realm.add(roller)
                    }
                    devicesList.append(roller)
                }
            }
        }
        if devicesList.count > 0 {
            return devicesList
        } else {
            return nil
        }
    }
}
