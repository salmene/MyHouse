//
//  CustomTabbar.swift
//  MyHome
//
//  Created by Salmen NOUIR on 31/01/2021.
//

import UIKit
import RxSwift
import RxCocoa

class CustomTabbar: UIView {
    
    let selectedTab: BehaviorRelay<TabItem>
    let tabs: [TabItem]
    private var itemViews: [TabbarItemView] = []
    private let disposeBag = DisposeBag()
    
    init(frame: CGRect, items: [TabItem], selectedTab: BehaviorRelay<TabItem>) {
        self.selectedTab = selectedTab
        self.tabs = items
        super.init(frame: frame)
        initUI()
        selectedTab.subscribe({[weak self] (_) in
            self?.reloadItemViewsSlection()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13, *),
           self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            self.applyShadow(y: -5, color: Ressources.Colors.shadow ?? .lightGray)
        }
    }
    
    /**
     This function initializes UI components
     */
    func initUI() {
        self.backgroundColor = Ressources.Colors.white
        self.applyShadow(y: -5, color: Ressources.Colors.shadow ?? .lightGray)
        let itemWidth = self.bounds.width / CGFloat(tabs.count)
        for i in 0..<tabs.count {
            let tabItemView = TabbarItemView(frame: CGRect(x: CGFloat(i) * itemWidth, y: 0, width: itemWidth, height: self.bounds.height), item: tabs[i])
            tabItemView.selectionAction = {[weak self] selectedItem in
                self?.selectedTab.accept(selectedItem)
            }
            self.addSubview(tabItemView)
            self.itemViews.append(tabItemView)
        }
    }
    
    /**
     This function allows to update tabbar item according to its selection status
     */
    private func reloadItemViewsSlection() {
        for itemV in itemViews {
            if itemV.item == selectedTab.value {
                itemV.setSelected(true)
            } else {
                itemV.setSelected(false)
            }
        }
    }
    
}
