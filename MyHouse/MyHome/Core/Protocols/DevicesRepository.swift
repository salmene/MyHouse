//
//  DevicesRepository.swift
//  MyHome
//
//  Created by Salmen NOUIR on 04/02/2021.
//

import Foundation

protocol DevicesRepository {
    func getDevices(completion: (([ConnectedObject]?, NetworkError?)->Void)?)
    func deleteDevice(_ deviceID: Int, type: ObjectType)
    func getDevice(with id: Int, type: ObjectType) -> ConnectedObject?
    func updateLight(_ deviceID: Int, newValue: Int, mode: ObjectMode)
    func updateHeater(_ deviceID: Int, newValue: Float, mode: ObjectMode)
    func updateRoller(_ deviceID: Int, newPosition: Int)
}
