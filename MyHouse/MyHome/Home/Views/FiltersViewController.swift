//
//  FiltersViewController.swift
//  MyHome
//
//  Created by Salmen NOUIR on 01/02/2021.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class FiltersViewController: UIViewController {
    
    private let viewModel: FiltersViewModel
    private let disposeBag = DisposeBag()
    var didUpdateFilter: (([ObjectType])->Void)?
    
    //MARK: UI Components
    private let mainView = UIView()
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private let cancelButton = UIButton()
    private let doneButton = UIButton()
    
    init(_ selectedTypes: [ObjectType], completion: (([ObjectType])->Void)?) {
        self.viewModel = DefaultFiltersViewModel(selectedTypes)
        didUpdateFilter = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bindToViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.addCornerRadius(10)
        doneButton.addCornerRadius(20)
        cancelButton.addCornerRadius(20)
    }
    
    /**
     This function initializes UI components
     */
    private func initUI() {
        self.view.backgroundColor = Ressources.Colors.black?.withAlphaComponent(0.5)
        mainView.backgroundColor = Ressources.Colors.white
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(300)
        }
        
        titleLabel.textColor = Ressources.Colors.mainDarkColor
        titleLabel.font = Ressources.Fonts.latoBold(18)
        titleLabel.text = Ressources.Strings.filtersTitle
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        mainView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        doneButton.setTitle(Ressources.Strings.doneButtonTitle, for: .normal)
        doneButton.setTitleColor(Ressources.Colors.white, for: .normal)
        doneButton.backgroundColor = Ressources.Colors.yellow
        doneButton.titleLabel?.font = Ressources.Fonts.dosisExtraBold(18)
        mainView.addSubview(doneButton)
        cancelButton.setTitle(Ressources.Strings.cancelButtonTitle, for: .normal)
        cancelButton.setTitleColor(Ressources.Colors.yellow, for: .normal)
        cancelButton.backgroundColor = Ressources.Colors.white
        cancelButton.titleLabel?.font = Ressources.Fonts.dosisExtraBold(18)
        mainView.addSubview(cancelButton)
        doneButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
            make.leading.equalTo(self.mainView.snp.centerX).offset(8)
            make.height.equalTo(40)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.trailing.equalTo(self.mainView.snp.centerX).offset(-8)
            make.height.equalTo(40)
        }
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = Ressources.Colors.yellow.cgColor
        
        tableView.backgroundColor = .clear
        mainView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(cancelButton.snp.top).offset(15)
        }
        tableView.register(FilterTypeTableViewCell.self, forCellReuseIdentifier: "filterCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
    }
    
    /**
     Bind & subscribe to viewModel properties
     */
    private func bindToViewModel() {
        viewModel.dataSource.bind(to: tableView.rx.items(cellIdentifier: "filterCell", cellType: FilterTypeTableViewCell.self)) { (row,item,cell) in
            cell.data = item
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected((ObjectType, Bool).self).subscribe(onNext: {[weak self] item in
            self?.viewModel.toggleTypeSelection(item.0)
        }).disposed(by: disposeBag)
        
        viewModel.isValidSelection.bind(to: doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValidSelection.subscribe(onNext: {[weak self] (isValid) in
            self?.doneButton.alpha = (isValid) ? 1.0 : 0.3
        }).disposed(by: disposeBag)

        cancelButton.rx.tap.subscribe(onNext: {[weak self] () in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        doneButton.rx.tap.subscribe(onNext: {[weak self] () in
            self?.didUpdateFilter?(self?.viewModel.selectedTypes ?? [.light, .heater, .rollerShutter])
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }

}
