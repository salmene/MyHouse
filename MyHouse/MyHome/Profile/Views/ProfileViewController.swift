//
//  ProfileViewController.swift
//  MyHome
//
//  Created by Salmen NOUIR on 03/02/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    
    private let viewModel: ProfileViewModel = DefaultProfileViewModel(DefaultUserRepository.sharedInstance)
    private let disposeBag = DisposeBag()
    
    //MARK: UI Components
    private let topView = UIView()
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        self.bindToViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.getUser()
    }
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13, *),
           self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            self.topView.applyShadow(y: 5, color: Ressources.Colors.shadow ?? .lightGray)
        }
    }
    
    /**
     This function initializes UI components
     */
    private func initUI() {
        self.view.backgroundColor = Ressources.Colors.white
        topView.backgroundColor = Ressources.Colors.white
        self.view.addSubview(tableView)
        self.view.addSubview(topView)
        topView.snp.makeConstraints {[unowned self] (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(70)
        }
        self.topView.applyShadow(y: 5, color: Ressources.Colors.shadow ?? .lightGray)
        
        let titleLabel = UILabel()
        titleLabel.textColor = Ressources.Colors.mainDarkColor
        titleLabel.font = Ressources.Fonts.dosisExtraBold(22)
        titleLabel.text = Ressources.Strings.profileMainTitle
        topView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        tableView.backgroundColor = .clear
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: "infoCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    }
    
    /**
     Bind & subscribe to viewModel properties
     */
    private func bindToViewModel() {
        viewModel.error.subscribe(onNext: {[weak self] error in
            DispatchQueue.main.async {
                self?.showInfoAlert(title: Ressources.Strings.errorTitle,
                                    message: error.getDescription(),
                                    buttonTitle: Ressources.Strings.alertDoneButton)
            }
        }).disposed(by: disposeBag)
        
        viewModel.dataSource.bind(to: tableView.rx.items(cellIdentifier: "infoCell", cellType: InfoTableViewCell.self)) { (row,item,cell) in
            cell.data = item
            cell.editBtnAction = {[weak self] type in
                let editVC: UIViewController
                if type == .address {
                    editVC = EditAddressViewController(self?.viewModel.addressData ?? [:])
                    (editVC as? EditAddressViewController)?.didUpdate = {[weak self] in
                        self?.viewModel.getUser()
                    }
                } else {
                    editVC = EditInfoViewController(type, oldValue: item.1 ?? "")
                    (editVC as? EditInfoViewController)?.didUpdate = {[weak self] in
                        self?.viewModel.getUser()
                    }
                }
                editVC.modalPresentationStyle = .overFullScreen
                editVC.modalTransitionStyle = .crossDissolve
                self?.present(editVC, animated: true, completion: nil)
            }
        }.disposed(by: disposeBag)
    }

}
