//
//  DefaultProfileViewModelTests.swift
//  MyHomeTests
//
//  Created by Salmen NOUIR on 04/02/2021.
//

@testable import MyHome
import XCTest

class DefaultProfileViewModelTests: XCTestCase {
    
    func testGetUser() throws {
        let address = Address.stub(streetCode: "2B", street: "rue Michelet", city: "Issy-les-Moulineaux", country: "France", postaleCode: 92130)
        let user = User.stub(firstName: "John", lastName: "Doe", birthDateSecond: 813766371, address: address)
        let dataManager = UserRepositoryMock(user)
        let defaultProfileViewModel = DefaultProfileViewModel(dataManager)
        defaultProfileViewModel.getUser()
        let dataSource = defaultProfileViewModel.dataSource.value
        let firstNameFromDS = dataSource.first(where: {$0.0 == .firstName})?.1
        XCTAssertEqual(firstNameFromDS, "John", "DataSource for first name not genrated")
        let lastNameFromDS = dataSource.first(where: {$0.0 == .lastName})?.1
        XCTAssertEqual(lastNameFromDS, "Doe", "DataSource for last name not genrated")
        let birthdateString = dataSource.first(where: {$0.0 == .birthDate})?.1
        XCTAssertEqual(birthdateString, "15-10-1995", "DataSource for birthdate not generated")
        
        XCTAssertEqual(defaultProfileViewModel.addressData[.streetCode], "2B", "Address Data not generated")
        XCTAssertEqual(defaultProfileViewModel.addressData[.street], "rue Michelet", "Address Data not generated")
        XCTAssertEqual(defaultProfileViewModel.addressData[.city], "Issy-les-Moulineaux", "Address Data not generated")
        XCTAssertEqual(defaultProfileViewModel.addressData[.country], "France", "Address Data not generated")
        XCTAssertEqual(defaultProfileViewModel.addressData[.postalCode], "92130", "Address Data not generated")
    }

}
