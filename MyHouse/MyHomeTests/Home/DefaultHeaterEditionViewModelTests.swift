//
//  DefaultHeaterEditionViewModelTests.swift
//  MyHomeTests
//
//  Created by Salmen NOUIR on 04/02/2021.
//

@testable import MyHome
import XCTest

class DefaultHeaterEditionViewModelTests: XCTestCase {

    private let lights = [Light.stub(id: 1, deviceName: "Light 1", mode: .on, intensity: 20)]
    private let heaters = [Heater.stub(id: 2, deviceName: "Heater 2", mode: .on, temp: 18.0)]
    private let rollers = [RollerShutter.stub(id: 3, deviceName: "Roller Shutter 3", position: 75)]

    func testUpdateHeater() throws {
        let dataManager: DevicesRepository = DevicesRepositoryMock(lights: lights, heaters: heaters, rollers: rollers)
        let defaultHeaterEditViewModel = DefaultHeaterEditionViewModel(deviceID: 2, manager: dataManager)
        defaultHeaterEditViewModel.updateHeater(20.0, mode: .off)
        XCTAssertEqual(defaultHeaterEditViewModel.temperature.value, 20.0, "Temperature not updated on view")
        XCTAssertEqual(defaultHeaterEditViewModel.deviceMode.value, .off, "Device mode not updated on view")
        let updatedHeater = dataManager.getDevice(with: 2, type: .heater) as! Heater
        XCTAssertEqual(updatedHeater.temperature.value, 20.0, "Temperature not updated successfully on Repository")
        XCTAssertEqual(updatedHeater.mode, .off, "Device mode not updated successfully on Repository")
    }

}
