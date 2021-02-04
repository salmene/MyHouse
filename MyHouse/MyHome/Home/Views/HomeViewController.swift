//
//  HomeViewController.swift
//  MyHome
//
//  Created by Salmen NOUIR on 31/01/2021.
//

import UIKit
import SnapKit
import RxSwift

class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModel = DefaultHomeViewModel(DefaultDevicesRepository.sharedInstance)
    private let disposeBag = DisposeBag()
    
    //MARK: UI Components
    private let topView = UIView()
    private let tableView = UITableView()
    private let filterButton = UIButton()
    private let editButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.bindToViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.getDevicesList()
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
        titleLabel.text = Ressources.Strings.homeMainTitle
        topView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        filterButton.setImage(Ressources.Images.filterIc, for: .normal)
        filterButton.tintColor = Ressources.Colors.mainDarkColor
        filterButton.contentMode = .scaleAspectFit
        filterButton.clipsToBounds = true
        topView.addSubview(filterButton)
        filterButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-23)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        editButton.setImage(Ressources.Images.editIc, for: .normal)
        editButton.tintColor = Ressources.Colors.mainDarkColor
        editButton.setTitleColor(Ressources.Colors.mainDarkColor, for: .normal)
        editButton.titleLabel?.font = Ressources.Fonts.latoBold(15)
        editButton.contentMode = .scaleAspectFit
        editButton.clipsToBounds = true
        topView.addSubview(editButton)
        editButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(23)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        tableView.backgroundColor = .clear
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView.register(DeviceTableViewCell.self, forCellReuseIdentifier: "deviceCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    }
    
    /**
     Bind & subscribe to viewModel properties
     */
    private func bindToViewModel() {
        self.viewModel.error.subscribe(onNext: {[weak self] error in
            DispatchQueue.main.async {
                self?.showInfoAlert(title: Ressources.Strings.errorTitle,
                                    message: error.getDescription(),
                                    buttonTitle: Ressources.Strings.alertDoneButton)
            }
        }).disposed(by: disposeBag)
        
        viewModel.devicesDataSource.bind(to: tableView.rx.items(cellIdentifier: "deviceCell", cellType: DeviceTableViewCell.self)) { (row,item,cell) in
            cell.viewModel = item
        }.disposed(by: disposeBag)
        
        filterButton.rx.tap.subscribe(onNext: {[weak self] () in
            let filterVC = FiltersViewController(self?.viewModel.selectedTypes ?? []) {[weak self] (newTypes) in
                self?.viewModel.applyFilter(newTypes)
            }
            filterVC.modalPresentationStyle = .overFullScreen
            filterVC.modalTransitionStyle = .crossDissolve
            self?.present(filterVC, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        editButton.rx.tap.subscribe(onNext: {[weak self] () in
            if let editing = self?.tableView.isEditing, editing {
                self?.tableView.setEditing(false, animated: true)
                self?.editButton.setImage(Ressources.Images.editIc, for: .normal)
                self?.editButton.setTitle("", for: .normal)
            } else {
                self?.tableView.setEditing(true, animated: true)
                self?.editButton.setImage(nil, for: .normal)
                self?.editButton.setTitle(Ressources.Strings.alertDoneButton, for: .normal)
            }
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: {[weak self] (indexPath) in
            guard let self = self else {
                return
            }
            let item = self.viewModel.devicesDataSource.value[indexPath.row]
            guard let deviceID = item.id, let type = item.type else {
                return
            }
            var detailsVC: UIViewController
            switch type {
            case .light:
                detailsVC = LightEditionViewController(deviceID)
            case .heater:
                detailsVC = HeaterEditionViewController(deviceID)
            case .rollerShutter:
                detailsVC = RollerEditionViewController(deviceID)
            }
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }).disposed(by: disposeBag)
        
        tableView.rx.itemDeleted.subscribe(onNext: {  [weak self] indexPath in
            self?.viewModel.deleteDevice(indexPath.row)
        }).disposed(by: disposeBag)
    }
    
}
