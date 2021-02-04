//
//  DefaultEditAddressViewModelTests.swift
//  MyHomeTests
//
//  Created by Salmen NOUIR on 04/02/2021.
//

@testable import MyHome
import XCTest

class DefaultEditAddressViewModelTests: XCTestCase {

    func testUpdateAddressOn() throws {
        let address = Address.stub(streetCode: "2B", street: "rue Michelet", city: "Issy-les-Moulineaux", country: "France", postaleCode: 92130)
        let user = User.stub(firstName: "John", lastName: "Doe", birthDateSecond: 813766371, address: address)
        let dataManager = UserRepositoryMock(user)
        let defaultEditAddressViewModel = DefaultEditAddressViewModel(dataManager, addressData: address.getAddressData())
        defaultEditAddressViewModel.streetCode.accept("10")
        defaultEditAddressViewModel.street.accept("Maréchal Foch")
        defaultEditAddressViewModel.city.accept("Houilles")
        defaultEditAddressViewModel.country.accept("FRANCE")
        defaultEditAddressViewModel.postalCode.accept("78800")
        defaultEditAddressViewModel.updateUser()
        dataManager.getUser { (user, error) in
            XCTAssertEqual(user?.address?.streetCode, "10", "address streetCode not updated")
            XCTAssertEqual(user?.address?.street, "Maréchal Foch", "address street not updated")
            XCTAssertEqual(user?.address?.city, "Houilles", "address city not updated")
            XCTAssertEqual(user?.address?.country, "FRANCE", "address country not updated")
            XCTAssertEqual(user?.address?.postalCode.value, 78800, "address country not updated")
        }
    }

}
