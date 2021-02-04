//
//  MainTabbarViewController.swift
//  MyHome
//
//  Created by Salmen NOUIR on 31/01/2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainTabbarViewController: UIViewController {
    
    private let viewModel = MainTabbarViewModel()
    private let homeVC = UINavigationController(rootViewController: HomeViewController())
    private let profileVC = ProfileViewController()
    
    private let disposeBag = DisposeBag()
    
    private let containerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.bindToViewModel()
    }
    
    /**
     This function intializes UI components
     */
    private func initUI() {
        self.view.addSubview(containerView)
        let tabbar = CustomTabbar(frame: CGRect(x: 0, y: 0,
                                                width: self.view.bounds.width, height: 80),
                                  items: TabItem.allTabItems(),
                                  selectedTab: viewModel.selectedTabItem)
        self.view.addSubview(tabbar)
        tabbar.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(tabbar.snp.top)
        }
        containerView.backgroundColor = Ressources.Colors.yellow
        self.view.backgroundColor = Ressources.Colors.white
        self.setInitialVC()
    }
    
    /**
     Bind & subscribe to viewModel properties
     */
    private func bindToViewModel() {
        self.viewModel.selectedTabItem.distinctUntilChanged().subscribe(onNext: {[weak self] (item) in
            guard let self = self else {
                return
            }
            switch item {
            case .home:
                self.profileVC.willMove(toParent: nil)
                self.profileVC.view.removeFromSuperview()
                self.profileVC.removeFromParent()
                self.addChild(self.homeVC)
                self.homeVC.view.frame = self.containerView.bounds
                self.containerView.addSubview(self.homeVC.view)
            case .profile:
                self.homeVC.willMove(toParent: nil)
                self.homeVC.view.removeFromSuperview()
                self.homeVC.removeFromParent()
                self.addChild(self.profileVC)
                self.profileVC.view.frame = self.containerView.bounds
                self.containerView.addSubview(self.profileVC.view)
            }
        }).disposed(by: disposeBag)
    }
    
    /**
     This function set the inital VC to the TabBar
     */
    private func setInitialVC() {
        homeVC.setNavigationBarHidden(true, animated: false)
        addChild(homeVC)
        homeVC.view.frame = containerView.bounds
        containerView.addSubview(homeVC.view)
        homeVC.didMove(toParent: self)
    }
    
}





