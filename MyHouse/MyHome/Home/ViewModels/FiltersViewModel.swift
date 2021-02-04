//
//  FiltersViewModel.swift
//  MyHome
//
//  Created by Salmen NOUIR on 01/02/2021.
//

import Foundation
import RxCocoa

protocol FiltersViewModel {
    var dataSource: BehaviorRelay<[(ObjectType, Bool)]> {get}
    var selectedTypes: [ObjectType] {get}
    var isValidSelection: BehaviorRelay<Bool> {get}
    func toggleTypeSelection(_ type: ObjectType)
}

final class DefaultFiltersViewModel: FiltersViewModel {
    
    var dataSource: BehaviorRelay<[(ObjectType, Bool)]> = BehaviorRelay(value: [])
    var selectedTypes: [ObjectType]
    var isValidSelection: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let allTypes: [ObjectType] = [.light, .heater, .rollerShutter]
    
    init(_ filter: [ObjectType]) {
        self.selectedTypes = filter
        self.isValidSelection.accept(selectedTypes.count != 0)
        self.updateDataSources()
    }
    
    /**
     This function toggle the selection status for a given type and refresh dataSource
     - Parameter type: the type to toggle its selection status
     */
    func toggleTypeSelection(_ type: ObjectType) {
        if let index = selectedTypes.firstIndex(of: type) {
            selectedTypes.remove(at: index)
        } else {
            selectedTypes.append(type)
        }
        isValidSelection.accept(selectedTypes.count != 0)
        updateDataSources()
    }
    
    /**
     This function refresh the dataSource
     */
    private func updateDataSources() {
        var newDataSource = [(ObjectType, Bool)]()
        for type in allTypes {
            if selectedTypes.contains(type) {
                newDataSource.append((type, true))
            } else {
                newDataSource.append((type, false))
            }
        }
        dataSource.accept(newDataSource)
    }
}
