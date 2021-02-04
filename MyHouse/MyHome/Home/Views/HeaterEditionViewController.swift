//
//  HeaterEditionViewController.swift
//  MyHome
//
//  Created by Salmen NOUIR on 02/02/2021.
//

import UIKit
import RxSwift
import RxCocoa

class HeaterEditionViewController: UIViewController {
    
    private let viewModel: HeaterEditionViewModel
    private let disposeBag = DisposeBag()
    
    init(_ deviceID: Int) {
        self.viewModel = DefaultHeaterEditionViewModel(deviceID: deviceID, manager: DefaultDevicesRepository.sharedInstance)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI Components
    private let backButton = UIButton()
    private let nameLabel = UILabel()
    private let typeIV = UIImageView()
    private let onOffSwitch = UISwitch()
    private let slider = CustomSlider()
    private let leftIV = UIImageView()
    private let rightIV = UIImageView()
    private let valueLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bindToViewModel()
    }
    
    /**
     This function initializes UI components
     */
    private func initUI() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.view.backgroundColor = Ressources.Colors.white
        
        backButton.setImage(Ressources.Images.leftArrow, for: .normal)
        backButton.tintColor = Ressources.Colors.mainDarkColor
        backButton.contentMode = .scaleAspectFit
        backButton.clipsToBounds = true
        view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.equalToSuperview().offset(23)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        typeIV.contentMode = .scaleAspectFit
        typeIV.clipsToBounds = true
        typeIV.image = Ressources.Images.heaterIc
        view.addSubview(typeIV)
        typeIV.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70)
            make.height.equalTo(150)
            make.width.equalTo(150)
        }
        nameLabel.textColor = Ressources.Colors.mainDarkColor
        nameLabel.font = Ressources.Fonts.latoBold(25)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        nameLabel.textAlignment = .center
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(30)
            make.top.equalTo(typeIV.snp.bottom).offset(50)
            make.trailing.equalToSuperview().offset(-30)
        }
        onOffSwitch.onTintColor = Ressources.Colors.yellow
        view.addSubview(onOffSwitch)
        onOffSwitch.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(50)
        }
        slider.minimumTrackTintColor = Ressources.Colors.yellow
        slider.maximumTrackTintColor = Ressources.Colors.mainDarkColor
        slider.minimumValue = 7
        slider.maximumValue = 28
        view.addSubview(slider)
        view.addSubview(leftIV)
        view.addSubview(rightIV)
        slider.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalTo(leftIV.snp.trailing).offset(20)
            make.trailing.equalTo(rightIV.snp.leading).offset(-20)
            make.top.equalTo(onOffSwitch.snp.bottom).offset(50)
        }
        
        leftIV.contentMode = .scaleAspectFit
        leftIV.clipsToBounds = true
        leftIV.image = Ressources.Images.coldIc
        leftIV.tintColor = Ressources.Colors.mainDarkColor
        leftIV.snp.makeConstraints { (make) in
            make.centerY.equalTo(slider.snp.bottom).offset(-4)
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(22)
            make.width.equalTo(22)
        }
        rightIV.contentMode = .scaleAspectFit
        rightIV.clipsToBounds = true
        rightIV.image = Ressources.Images.hotIc
        rightIV.tintColor = Ressources.Colors.yellow
        rightIV.snp.makeConstraints { (make) in
            make.centerY.equalTo(slider.snp.bottom).offset(-4)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(22)
            make.width.equalTo(22)
        }
        
        valueLabel.textColor = Ressources.Colors.mainDarkColor
        valueLabel.font = Ressources.Fonts.latoRegular(21)
        valueLabel.textAlignment = .center
        view.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(30)
            make.top.equalTo(slider.snp.bottom).offset(50)
            make.trailing.equalToSuperview().offset(-30)
        }
    }
    
    /**
     Bind & subscribe to viewModel properties
     */
    private func bindToViewModel() {
        viewModel.deviceName.bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.deviceMode.map { (mode) -> UIColor? in
            switch mode {
            case .on:
                return Ressources.Colors.yellow
            case .off:
                return Ressources.Colors.mainDarkColor
            }
        }.bind(to: typeIV.rx.tintColor)
        .disposed(by: disposeBag)
        
        viewModel.deviceMode.map {$0 == .on}.bind(to: onOffSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        onOffSwitch.rx.isOn.distinctUntilChanged().map { (isON) -> ObjectMode in
            if isON {
                return .on
            } else {
                return .off
            }
        }.subscribe(onNext: {[weak self] newMode in
            guard let self = self else {
                return
            }
            self.viewModel.updateHeater(self.viewModel.temperature.value, mode: newMode)
        }).disposed(by: disposeBag)
        
        viewModel.temperature.map{Float($0)}.bind(to: slider.rx.value)
            .disposed(by: disposeBag)
        
        viewModel.deviceMode.subscribe(onNext: {[weak self] mode in
            DispatchQueue.main.async {
                self?.slider.isEnabled = (mode == .on)
                self?.slider.alpha = (mode == .on) ? 1.0 : 0.5
            }
        }).disposed(by: disposeBag)
        
        slider.rx.value.subscribe(onNext: {[weak self] value in
            guard let self = self else {
                return
            }
            let roundedValue = Float(round(value / 0.5) * 0.5)
            self.viewModel.updateHeater(roundedValue, mode: self.viewModel.deviceMode.value)
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.subscribe(onNext: {[weak self] () in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.temperature.subscribe(onNext: {[weak self] temp in
            self?.valueLabel.text = String(format: Ressources.Strings.heaterValue, temp)
        }).disposed(by: disposeBag)
        
        self.viewModel.error.subscribe(onNext: {[weak self] error in
            DispatchQueue.main.async {
                self?.showInfoAlert(title: Ressources.Strings.errorTitle,
                                    message: error.getDescription(),
                                    buttonTitle: Ressources.Strings.alertDoneButton)
            }
        }).disposed(by: disposeBag)
    }

}

