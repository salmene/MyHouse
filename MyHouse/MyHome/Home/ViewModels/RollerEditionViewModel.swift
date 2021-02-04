//
//  RollerEditionViewModel.swift
//  MyHome
//
//  Created by Salmen NOUIR on 02/02/2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol RollerEditionViewModel {
    var deviceName: BehaviorRelay<String> {get}
    var position: BehaviorRelay<Int> {get}
    var error: PublishSubject<NetworkError> {get}
    func updateRoller(_ newPosition: Int)
}

final class DefaultRollerEditionViewModel: RollerEditionViewModel {
    
    var deviceID: Int
    var deviceName: BehaviorRelay<String> = BehaviorRelay(value: "")
    var position: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var error: PublishSubject<NetworkError> = PublishSubject<NetworkError>()
    var dataManager: DevicesRepository
    
    init(deviceID: Int, manager: DevicesRepository) {
        self.dataManager = manager
        self.deviceID = deviceID
        guard let device = manager.getDevice(with: self.deviceID, type: .rollerShutter) as? RollerShutter else {
            error.onNext(.notFound)
            return
        }
        self.deviceName.accept(device.deviceName ?? "")
        self.position.accept(device.position.value ?? 0)
    }
    
    /**
     This function update the roller shutter's psotion and refresh the view's data
     - Parameter newPosition: the new position to be setted
     */
    func updateRoller(_ newPosition: Int) {
        position.accept(newPosition)
        dataManager.updateRoller(deviceID, newPosition: newPosition)
    }
}
