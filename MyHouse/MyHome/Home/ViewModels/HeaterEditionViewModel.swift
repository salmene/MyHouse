//
//  HeaterEditionViewModel.swift
//  MyHome
//
//  Created by Salmen NOUIR on 02/02/2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol HeaterEditionViewModel {
    var deviceName: BehaviorRelay<String> {get}
    var deviceMode: BehaviorRelay<ObjectMode> {get}
    var temperature: BehaviorRelay<Float> {get}
    var error: PublishSubject<NetworkError> {get}
    func updateHeater(_ newIntensity: Float, mode: ObjectMode)
}

final class DefaultHeaterEditionViewModel: HeaterEditionViewModel {
    
    var deviceID: Int
    var deviceName: BehaviorRelay<String> = BehaviorRelay(value: "")
    var deviceMode: BehaviorRelay<ObjectMode> = BehaviorRelay(value: .off)
    var temperature: BehaviorRelay<Float> = BehaviorRelay(value: 0)
    var error: PublishSubject<NetworkError> = PublishSubject<NetworkError>()
    var dataManager: DevicesRepository
    
    init(deviceID: Int, manager: DevicesRepository) {
        self.dataManager = manager
        self.deviceID = deviceID
        guard let device = manager.getDevice(with: self.deviceID, type: .heater) as? Heater else {
            error.onNext(.notFound)
            return
        }
        self.deviceName.accept(device.deviceName ?? "")
        self.deviceMode.accept(device.mode ?? .off)
        self.temperature.accept(device.temperature.value ?? 0)
    }
    
    /**
     This function update the heater's properties and refresh the view's data
     - Parameters:
        - newTemp: the new temperature to be setted
        - mode: the new mode (ON/OFF) to be setted
     */
    func updateHeater(_ newTemp: Float, mode: ObjectMode) {
        temperature.accept(newTemp)
        deviceMode.accept(mode)
        dataManager.updateHeater(deviceID, newValue: newTemp, mode: mode)
    }
}
