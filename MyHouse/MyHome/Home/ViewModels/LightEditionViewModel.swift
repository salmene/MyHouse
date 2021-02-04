//
//  LHEditionViewModel.swift
//  MyHome
//
//  Created by Salmen NOUIR on 01/02/2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol LightEditionViewModel {
    var deviceName: BehaviorRelay<String> {get}
    var deviceMode: BehaviorRelay<ObjectMode> {get}
    var intensity: BehaviorRelay<Int> {get}
    var error: PublishSubject<NetworkError> {get}
    func updateLight(_ newIntensity: Int, mode: ObjectMode)
}

final class DefaultLightEditionViewModel: LightEditionViewModel {
    
    var deviceID: Int
    var deviceName: BehaviorRelay<String> = BehaviorRelay(value: "")
    var deviceMode: BehaviorRelay<ObjectMode> = BehaviorRelay(value: .off)
    var intensity: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var error: PublishSubject<NetworkError> = PublishSubject<NetworkError>()
    var dataManager: DevicesRepository
    
    init(deviceID: Int, manager: DevicesRepository) {
        self.dataManager = manager
        self.deviceID = deviceID
        guard let device = manager.getDevice(with: self.deviceID, type: .light) as? Light else {
            error.onNext(.notFound)
            return
        }
        self.deviceName.accept(device.deviceName ?? "")
        self.deviceMode.accept(device.mode ?? .off)
        self.intensity.accept(device.intensity.value ?? 0)
    }
    
    /**
     This function update the light's properties and refresh the view's data
     - Parameters:
        - newIntensity: the new intensity to be setted
        - mode: the new mode (ON/OFF) to be setted
     */
    func updateLight(_ newIntensity: Int, mode: ObjectMode) {
        intensity.accept(newIntensity)
        deviceMode.accept(mode)
        dataManager.updateLight(deviceID, newValue: newIntensity, mode: mode)
    }
}
