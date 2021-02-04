//
//  DefaultLightEditionViewModelTests.swift
//  MyHomeTests
//
//  Created by Salmen NOUIR on 04/02/2021.
//

@testable import MyHome
import XCTest

class DefaultLightEditionViewModelTests: XCTestCase {

    private let lights = [Light.stub(id: 1, deviceName: "Light 1", mode: .on, intensity: 20)]
    private let heaters = [Heater.stub(id: 2, deviceName: "Heater 2", mode: .on, temp: 18.0)]
    private let rollers = [RollerShutter.stub(id: 3, deviceName: "Roller Shutter 3", position: 75)]

    func testUpdateLight() throws {
        let dataManager: DevicesRepository = DevicesRepositoryMock(lights: lights, heaters: heaters, rollers: rollers)
        let defaultLightEditViewModel = DefaultLightEditionViewModel(deviceID: 1, manager: dataManager)
        defaultLightEditViewModel.updateLight(35, mode: .off)
        XCTAssertEqual(defaultLightEditViewModel.intensity.value, 35, "Intensity not updated on view")
        XCTAssertEqual(defaultLightEditViewModel.deviceMode.value, .off, "Device mode not updated on view")
        let updatedLight = dataManager.getDevice(with: 1, type: .light) as! Light
        XCTAssertEqual(updatedLight.intensity.value, 35, "Intensity not updated successfully on Repository")
        XCTAssertEqual(updatedLight.mode, .off, "Device mode not updated successfully on Repository")
    }

}
