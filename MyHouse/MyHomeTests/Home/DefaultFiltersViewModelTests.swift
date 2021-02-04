//
//  DefaultFiltersViewModelTests.swift
//  MyHomeTests
//
//  Created by Salmen NOUIR on 04/02/2021.
//

@testable import MyHome
import XCTest

class DefaultFiltersViewModelTests: XCTestCase {
    
    private let allFilters = [ObjectType.light, ObjectType.heater, ObjectType.rollerShutter]

    func testToggleSelection() throws {
        let defaultFilterViewModel = DefaultFiltersViewModel(allFilters)
        defaultFilterViewModel.toggleTypeSelection(.heater)
        let heaterDS = defaultFilterViewModel.dataSource.value.first { (type, selected) -> Bool in
            return type == .heater
        }
        XCTAssertFalse(heaterDS!.1, "Filter status not toggled successfully")
    }
    
    func testValidation() throws {
        let defaultFilterViewModel = DefaultFiltersViewModel(allFilters)
        defaultFilterViewModel.toggleTypeSelection(.heater)
        XCTAssertTrue(defaultFilterViewModel.isValidSelection.value, "The valid status should be true")
        defaultFilterViewModel.toggleTypeSelection(.light)
        defaultFilterViewModel.toggleTypeSelection(.rollerShutter)
        XCTAssertFalse(defaultFilterViewModel.isValidSelection.value, "The valid status should be true")
    }

}
