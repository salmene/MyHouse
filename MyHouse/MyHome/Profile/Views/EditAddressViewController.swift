//
//  EditAddressViewController.swift
//  MyHome
//
//  Created by Salmen NOUIR on 03/02/2021.
//

import UIKit
import RxSwift
import RxCocoa

class EditAddressViewController: UIViewController {
    
    private let viewModel: EditAddressViewModel
    private let disposeBag = DisposeBag()
    
    var didUpdate: (()->Void)?
    
    //MARK: UI Components
    private let mainView = UIView()
    private let titleLabel = UILabel()
    private let streetCodeTF = UITextField()
    private let streetTF = UITextField()
    private let cityTF = UITextField()
    private let postalCodeTF = UITextField()
    private let countryTF = UITextField()
    private let cancelButton = UIButton()
    private let doneButton = UIButton()
    
    init(_ oldData: [AddressCompoenent: String]) {
        self.viewModel = DefaultEditAddressViewModel(DefaultUserRepository.sharedInstance, addressData: oldData)
        super.init(nibName: nil, bundle: nil)
        self.fillTextFieldsWithData(oldData)
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
     This function initializes all textfields with old addrress infos and set placeHolders
     - Parameter data: the old address data as Dictionary (key:value)
     */
    private func fillTextFieldsWithData(_ data: [AddressCompoenent: String]) {
        streetCodeTF.text = data[.streetCode]
        streetCodeTF.placeholder = AddressCompoenent.streetCode.getTitle()
        streetTF.text = data[.street]
        streetTF.placeholder = AddressCompoenent.street.getTitle()
        cityTF.text = data[.city]
        cityTF.placeholder = AddressCompoenent.city.getTitle()
        postalCodeTF.text = data[.postalCode]
        postalCodeTF.placeholder = AddressCompoenent.postalCode.getTitle()
        countryTF.text = data[.country]
        countryTF.placeholder = AddressCompoenent.country.getTitle()
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
            make.height.equalTo(400)
        }
        
        titleLabel.textColor = Ressources.Colors.mainDarkColor
        titleLabel.font = Ressources.Fonts.latoBold(18)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = Ressources.Strings.editAddressTitle
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
        
        let allTextField = [streetCodeTF, streetTF, cityTF, postalCodeTF, countryTF]
        allTextField.forEach { (textField) in
            textField.backgroundColor = .clear
            textField.borderStyle = .roundedRect
            textField.textAlignment = .center
            textField.autocorrectionType = .no
            mainView.addSubview(textField)
        }
        postalCodeTF.keyboardType = .numberPad
        
        streetCodeTF.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(40)
        }
        streetTF.snp.makeConstraints { (make) in
            make.top.equalTo(streetCodeTF.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(40)
        }
        cityTF.snp.makeConstraints { (make) in
            make.top.equalTo(streetTF.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(40)
        }
        postalCodeTF.snp.makeConstraints { (make) in
            make.top.equalTo(cityTF.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(40)
        }
        countryTF.snp.makeConstraints { (make) in
            make.top.equalTo(postalCodeTF.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(40)
        }
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: {[weak self] notification in
                UIView.animate(withDuration: 0.5) {
                    self?.mainView.snp.updateConstraints({ (make) in
                        make.centerY.equalToSuperview().offset(-90)
                    })
                }
            }).disposed(by: disposeBag)
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: {[weak self] notification in
                UIView.animate(withDuration: 0.5) {
                    self?.mainView.snp.updateConstraints({ (make) in
                        make.centerY.equalToSuperview()
                    })
                }
            }).disposed(by: disposeBag)
    }
    
    /**
     Bind & subscribe to viewModel properties
     */
    private func bindToViewModel() {
        let streetCodeValid = streetCodeTF.rx.text.orEmpty.map {$0.count > 0}
        let streetValid = streetTF.rx.text.orEmpty.map {$0.count > 0}
        let cityValid = cityTF.rx.text.orEmpty.map {$0.count > 0}
        let postalCodeValid = postalCodeTF.rx.text.orEmpty.map {$0.count > 0}
        let countryValid = countryTF.rx.text.orEmpty.map {$0.count > 0}
        
        let validObservable = Observable.combineLatest(streetCodeValid, streetValid,
                                                       cityValid, postalCodeValid,
                                                       countryValid) { (scv, sv, cv, pcv, couv) -> Bool in
            return scv && sv && cv && pcv && couv
        }
        validObservable.subscribe(onNext: {[weak self] isValid in
            self?.doneButton.isEnabled = isValid
            self?.doneButton.alpha = (isValid) ? 1.0 : 0.3
        }).disposed(by: disposeBag)

        streetCodeTF.rx.text.orEmpty.bind(to: self.viewModel.streetCode).disposed(by: disposeBag)
        streetTF.rx.text.orEmpty.bind(to: self.viewModel.street).disposed(by: disposeBag)
        cityTF.rx.text.orEmpty.bind(to: self.viewModel.city).disposed(by: disposeBag)
        postalCodeTF.rx.text.orEmpty.bind(to: self.viewModel.postalCode).disposed(by: disposeBag)
        countryTF.rx.text.orEmpty.bind(to: self.viewModel.country).disposed(by: disposeBag)
        
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
