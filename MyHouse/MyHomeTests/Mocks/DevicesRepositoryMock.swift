//
//  DevicesRepositoryMock.swift
//  MyHomeTests
//
//  Created by Salmen NOUIR on 04/02/2021.
//

@testable import MyHome
import Foundation

class DevicesRepositoryMock: DevicesRepository {
    
    private var lights = [Light]()
    private var heaters = [Heater]()
    private var rollers = [RollerShutter]()
    private var allDevices = [ConnectedObject]()
    
    init(lights: [Light], heaters: [Heater], rollers: [RollerShutter]) {
        self.lights = lights
        self.heaters = heaters
        self.rollers = rollers
        allDevices = lights + heaters + rollers
    }
    
    func getDevices(completion: (([ConnectedObject]?, NetworkError?) -> Void)?) {
        allDevices = lights + heaters + rollers
        completion?(allDevices, nil)
    }
    
    func deleteDevice(_ deviceID: Int, type: ObjectType) {
        let index = allDevices.firstIndex(where: { (objc) -> Bool in
            return objc.id.value == deviceID
        })
        if let index = index {
            allDevices.remove(at: index)
        }
        switch type {
        case .light:
            let lightIndex = lights.firstIndex(where: { (objc) -> Bool in
                return objc.id.value == deviceID
            })
            if let lightIndex = lightIndex {
                lights.remove(at: lightIndex)
            }
        case .heater:
            let heaterIndex = heaters.firstIndex(where: { (objc) -> Bool in
                return objc.id.value == deviceID
            })
            if let heaterIndex = heaterIndex {
                heaters.remove(at: heaterIndex)
            }
        case .rollerShutter:
            let rollerIndex = rollers.firstIndex(where: { (objc) -> Bool in
                return objc.id.value == deviceID
            })
            if let rollerIndex = rollerIndex {
                rollers.remove(at: rollerIndex)
            }
        }
    }
    
    func getDevice(with id: Int, type: ObjectType) -> ConnectedObject? {
        switch type {
        case .light:
            return lights.first { (light) -> Bool in
                light.id.value == id
            }
        case .heater:
            return heaters.first { (heater) -> Bool in
                heater.id.value == id
            }
        case .rollerShutter:
            return rollers.first { (roller) -> Bool in
                roller.id.value == id
            }
        }
    }
    
    func updateLight(_ deviceID: Int, newValue: Int, mode: ObjectMode) {
        let light = lights.first { (light) -> Bool in
            light.id.value == deviceID
        }
        light?.intensity.value = newValue
        light?.mode = mode
    }
    
    func updateHeater(_ deviceID: Int, newValue: Float, mode: ObjectMode) {
        let heater = heaters.first { (heater) -> Bool in
            heater.id.value == deviceID
        }
        heater?.temperature.value = newValue
        heater?.mode = mode
    }
    
    func updateRoller(_ deviceID: Int, newPosition: Int) {
        let roller = rollers.first { (roller) -> Bool in
            roller.id.value == deviceID
        }
        roller?.position.value = newPosition
    }
    
}
