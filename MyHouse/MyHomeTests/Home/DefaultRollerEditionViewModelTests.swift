//
//  DefaultRollerEditionViewModelTests.swift
//  MyHomeTests
//
//  Created by Salmen NOUIR on 04/02/2021.
//

@testable import MyHome
import XCTest

class DefaultRollerEditionViewModelTests: XCTestCase {

    private let lights = [Light.stub(id: 1, deviceName: "Light 1", mode: .on, intensity: 20)]
    private let heaters = [Heater.stub(id: 2, deviceName: "Heater 2", mode: .on, temp: 18.0)]
    private let rollers = [RollerShutter.stub(id: 3, deviceName: "Roller Shutter 3", position: 75)]

    func testUpdateHeater() throws {
        let dataManager: DevicesRepository = DevicesRepositoryMock(lights: lights, heaters: heaters, rollers: rollers)
        let defaultRollerEditViewModel = DefaultRollerEditionViewModel(deviceID: 3, manager: dataManager)
        defaultRollerEditViewModel.updateRoller(60)
        XCTAssertEqual(defaultRollerEditViewModel.position.value, 60, "Position not updated on view")
        let updatedRoller = dataManager.getDevice(with: 3, type: .rollerShutter) as! RollerShutter
        XCTAssertEqual(updatedRoller.position.value, 60, "Position not updated successfully on Repository")
    }

}
