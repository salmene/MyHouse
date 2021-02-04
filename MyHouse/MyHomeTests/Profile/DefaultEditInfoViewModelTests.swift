//
//  DefaultEditInfoViewModelTests.swift
//  MyHomeTests
//
//  Created by Salmen NOUIR on 04/02/2021.
//

@testable import MyHome
import XCTest

class DefaultEditInfoViewModelTests: XCTestCase {

    func testUpdateFirstName() throws {
        let user = User.stub(firstName: "John", lastName: "Doe", birthDateSecond: 813766371, address: nil)
        let dataManager = UserRepositoryMock(user)
        let defaultEditInfoViewModel = DefaultEditInfoViewModel(dataManager, type: .firstName, oldValue: "John")
        defaultEditInfoViewModel.infoValue.accept("Zack")
        defaultEditInfoViewModel.updateUser()
        dataManager.getUser { (user, error) in
            XCTAssertEqual(user?.firstName, "Zack", "User firstName not updated")
        }
    }
    
    func testUpdateLastName() throws {
        let user = User.stub(firstName: "John", lastName: "Doe", birthDateSecond: 813766371, address: nil)
        let dataManager = UserRepositoryMock(user)
        let defaultEditInfoViewModel = DefaultEditInfoViewModel(dataManager, type: .lastName, oldValue: "John")
        defaultEditInfoViewModel.infoValue.accept("Alain")
        defaultEditInfoViewModel.updateUser()
        dataManager.getUser { (user, error) in
            XCTAssertEqual(user?.lastName, "Alain", "User lastName not updated")
        }
    }
    
    func testUpdateBirthdate() throws {
        let user = User.stub(firstName: "John", lastName: "Doe", birthDateSecond: 813766371, address: nil)
        let dataManager = UserRepositoryMock(user)
        let defaultEditInfoViewModel = DefaultEditInfoViewModel(dataManager, type: .birthDate, oldValue: "John")
        defaultEditInfoViewModel.infoValue.accept("21-02-2000")
        defaultEditInfoViewModel.updateUser()
        dataManager.getUser { (user, error) in
            XCTAssertEqual(user!.getBirthDate()!, defaultEditInfoViewModel.getDate()!, "User lastName not updated")
        }
    }

}
