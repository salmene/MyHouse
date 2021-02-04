//
//  HomeViewModelTests.swift
//  MyHomeTests
//
//  Created by Salmen NOUIR on 04/02/2021.
//

@testable import MyHome
import XCTest

class DefaultHomeViewModelTests: XCTestCase {

    private let lights = [Light.stub(id: 1, deviceName: "Light 1", mode: .on, intensity: 20)]
    private let heaters = [Heater.stub(id: 2, deviceName: "Heater 2", mode: .on, temp: 18.0)]
    private let rollers = [RollerShutter.stub(id: 3, deviceName: "Roller Shutter 3", position: 75)]

    func testGetDevices() throws {
        let dataManager: DevicesRepository = DevicesRepositoryMock(lights: lights, heaters: heaters, rollers: rollers)
        let homeViewModel = DefaultHomeViewModel(dataManager)
        homeViewModel.getDevicesList()
        XCTAssertTrue(homeViewModel.devicesDataSource.value.count == 3, "DataSource has not been refreshed")
    }
    
    func testApplyFilter() throws {
        let dataManager: DevicesRepository = DevicesRepositoryMock(lights: lights, heaters: heaters, rollers: rollers)
        let homeViewModel = DefaultHomeViewModel(dataManager)
        homeViewModel.getDevicesList()
        XCTAssertTrue(homeViewModel.devicesDataSource.value.count == 3, "DataSource has not been refreshed")
        homeViewModel.applyFilter([.light, .heater])
        XCTAssertTrue(homeViewModel.devicesDataSource.value.count == 2, "DataSource not refreshed after applying filter")
    }
    
    func testDeleteDevice() throws {
        let dataManager: DevicesRepository = DevicesRepositoryMock(lights: lights, heaters: heaters, rollers: rollers)
        let homeViewModel = DefaultHomeViewModel(dataManager)
        homeViewModel.getDevicesList()
        XCTAssertTrue(homeViewModel.devicesDataSource.value.count == 3, "DataSource has not been refreshed")
        homeViewModel.deleteDevice(1)
        XCTAssertTrue(homeViewModel.devicesDataSource.value.count == 2, "Device not deleted")
        let heater = homeViewModel.devicesDataSource.value.first { (device) -> Bool in
            return device.type == .heater
        }
        XCTAssertNil(heater, "Data not correctly refreshed after delete")
    }

}
