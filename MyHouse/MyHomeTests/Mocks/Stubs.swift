//
//  Stubs.swift
//  MyHomeTests
//
//  Created by Salmen NOUIR on 04/02/2021.
//

@testable import MyHome
import Foundation

extension ConnectedObject {
    static func stub(id: Int?, deviceName: String?, type: ObjectType?) -> ConnectedObject {
        let  objc = ConnectedObject()
        objc.id.value = id
        objc.deviceName = deviceName
        objc.productType = type
        return objc
    }
}

extension Light {
    
    static func stub(id: Int?, deviceName: String?,
                     mode: ObjectMode?, intensity: Int?) -> Light {
        let light = Light()
        light.id.value = id
        light.deviceName = deviceName
        light.productType = .light
        light.mode = mode
        light.intensity.value = intensity
        return light
    }
}

extension Heater {
    
    static func stub(id: Int?, deviceName: String?,
                     mode: ObjectMode?, temp: Float?) -> Heater {
        let heater = Heater()
        heater.id.value = id
        heater.deviceName = deviceName
        heater.productType = .heater
        heater.mode = mode
        heater.temperature.value = temp
        return heater
    }
}

extension RollerShutter {
    
    static func stub(id: Int?, deviceName: String?, position: Int?) -> RollerShutter {
        let roller = RollerShutter()
        roller.id.value = id
        roller.deviceName = deviceName
        roller.productType = .rollerShutter
        roller.position.value = position
        return roller
    }
}

extension Address {
    static func stub(streetCode: String?, street: String?,
                     city: String?, country: String?,
                     postaleCode: Int?) -> Address {
        let address = Address()
        address.streetCode = streetCode
        address.street = street
        address.city = city
        address.country = country
        address.postalCode.value = postaleCode
        return address
    }
    
    func getAddressData() -> [AddressCompoenent: String] {
        var addressData = [AddressCompoenent: String]()
        addressData[.streetCode] = self.streetCode ?? ""
        addressData[.street] = self.street ?? ""
        addressData[.city] = self.city ?? ""
        addressData[.postalCode] = (self.postalCode.value != nil) ? "\(self.postalCode.value!)" : ""
        addressData[.country] = self.country ?? ""
        return addressData
    }
}

extension User {
    static func stub(firstName: String?, lastName: String?,
                     birthDateSecond: Int64?, address: Address?) -> User {
        let user = User()
        user.firstName = firstName
        user.lastName = lastName
        user.birthdate.value = birthDateSecond
        user.address = address
        return user
    }
}
