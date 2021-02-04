//
//  EditInfoViewController.swift
//  MyHome
//
//  Created by Salmen NOUIR on 03/02/2021.
//

import UIKit
import RxSwift
import RxCocoa

class EditInfoViewController: UIViewController {

    private let viewModel: EditInfoViewModel
    private let disposeBag = DisposeBag()
    
    var didUpdate: (()->Void)?
    
    //MARK: UI Components
    private let mainView = UIView()
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let cancelButton = UIButton()
    private let doneButton = UIButton()
    
    init(_ type: UserInfo, oldValue: String) {
        self.viewModel = DefaultEditInfoViewModel(DefaultUserRepository.sharedInstance,
                                                  type: type,
                                                  oldValue: oldValue)
        textField.text = oldValue
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
            make.height.equalTo(200)
        }
        
        titleLabel.textColor = Ressources.Colors.mainDarkColor
        titleLabel.font = Ressources.Fonts.latoBold(18)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        mainView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        doneButton.setTitle(Ressources.Strings.editInfoSaveBtnTitle, for: .normal)
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
        
        textField.backgroundColor = .clear
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.autocorrectionType = .no
        mainView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(40)
        }
        switch viewModel.infoType {
        case .firstName:
            titleLabel.text = Ressources.Strings.editFNameTitle
            textField.placeholder = Ressources.Strings.firstNameTitle
        case .lastName:
            titleLabel.text = Ressources.Strings.editLNameTitle
            textField.placeholder = Ressources.Strings.lastNameTitle
        case .birthDate:
            titleLabel.text = Ressources.Strings.editBirthdateTitle
            textField.placeholder = Ressources.Strings.birthDateTitle
            let datePickerView = UIDatePicker()
            datePickerView.locale = Locale.current
            datePickerView.datePickerMode = .date
            if #available(iOS 13.4, *) {
                datePickerView.preferredDatePickerStyle = .wheels
            }
            datePickerView.setDate(self.viewModel.getDate() ?? Date(), animated: false)
            datePickerView.rx.date.subscribe(onNext: {[weak self] date in
                self?.textField.text = DateHelper.getDateString(date)
                self?.viewModel.infoValue.accept(DateHelper.getDateString(date))
            }).disposed(by: disposeBag)
            textField.inputView = datePickerView
        default:
            break
        }
    }
    
    /**
     Bind & subscribe to viewModel properties
     */
    private func bindToViewModel() {
        textField.rx.text.map { (text) -> Bool in
            if let text = text, text.count > 0 {
                return true
            } else {
                return false
            }
        }.subscribe(onNext: {[weak self] (isValid) in
            self?.doneButton.isEnabled = isValid
            self?.doneButton.alpha = (isValid) ? 1.0 : 0.3
        }).disposed(by: disposeBag)

        textField.rx.text.orEmpty.bind(to: self.viewModel.infoValue).disposed(by: disposeBag)
        
        cancelButton.rx.tap.subscribe(onNext: {[weak self] () in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        doneButton.rx.tap.subscribe(onNext: {[weak self] () in
            self?.viewModel.updateUser()
            self?.didUpdate?()
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }

}
