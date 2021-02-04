//
//  MainTabbarViewModel.swift
//  MyHome
//
//  Created by Salmen NOUIR on 31/01/2021.
//

import UIKit
import RxSwift
import RxCocoa

enum TabItem {
    case home
    case profile
    
    static func allTabItems() -> [TabItem] {
        return [.home, .profile]
    }
    
    func getIcon() -> UIImage? {
        switch self {
        case .home:
            return Ressources.Images.homeIc
        case .profile:
            return Ressources.Images.profileIc
        }
    }
    
    func getTitle() -> String {
        switch self {
        case .home:
            return Ressources.Strings.homeTitle
        case .profile:
            return Ressources.Strings.profileTitle
        }
    }
}

final class MainTabbarViewModel {
    
    let selectedTabItem: BehaviorRelay<TabItem> = BehaviorRelay(value: .home)
    
}
