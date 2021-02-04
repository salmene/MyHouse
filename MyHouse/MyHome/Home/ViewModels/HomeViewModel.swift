//
//  HomeViewModel.swift
//  MyHome
//
//  Created by Salmen NOUIR on 31/01/2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModel {
    var devicesDataSource: BehaviorRelay<[DeviceCellViewModel]> {get set}
    var selectedTypes: [ObjectType] {get}
    var error: PublishSubject<NetworkError> {get}
    func getDevicesList()
    func applyFilter(_ filters: [ObjectType])
    func deleteDevice( _ at: Int)
}

final class DefaultHomeViewModel: HomeViewModel {
    
    var devicesDataSource: BehaviorRelay<[DeviceCellViewModel]> = BehaviorRelay(value: [])
    var selectedTypes: [ObjectType] = [.light, .heater, .rollerShutter]
    var error: PublishSubject<NetworkError> = PublishSubject()
    var dataManager: DevicesRepository
    
    private var allDevices = [DeviceCellViewModel]()
    
    init(_ manager: DevicesRepository) {
        self.dataManager = manager
    }
    
    /**
     This function get devices from repository and refresh dataSource
     */
    func getDevicesList() {
        dataManager.getDevices {[weak self] (objects, error) in
            guard let self = self else { return }
            guard let objects = objects, error == nil else {
                if let error = error {
                    self.error.onNext(error)
                } else {
                    self.error.onNext(NetworkError.defaultError)
                }
                return
            }
            self.allDevices = objects.map {DeviceCellViewModel($0)}
            self.applyFilter(self.selectedTypes)
        }
    }
    
    /**
     This function refresh dataSource according to selected filters
     - Parameter filters: The filtred to be applied to dataSource
     */
    func applyFilter(_ filters: [ObjectType]) {
        self.selectedTypes = filters
        self.devicesDataSource.accept(self.getFiltredDevices())
    }
    
    /**
     This function return the list of devices' VM data after filter is applied
     - Returns: list of devices' VM data
     */
    private func getFiltredDevices() -> [DeviceCellViewModel] {
        let filtredDevices = self.allDevices.filter {[weak self] (object) -> Bool in
            guard let objType = object.type else {
                return false
            }
            return self?.selectedTypes.contains(objType) ?? false
        }
        return filtredDevices
    }
    
    /**
     This function deletes a device with its index
     - Parameter at: index of device to be deleted on dataSource
     */
    func deleteDevice( _ at: Int) {
        let deviceToDelete = self.devicesDataSource.value[at]
        guard let deviceID = deviceToDelete.id, let deviceType = deviceToDelete.type else {
            self.error.onNext(NetworkError.defaultError)
            return
        }
        dataManager.deleteDevice(deviceID, type: deviceType)
        self.getDevicesList()
    }
    
}
