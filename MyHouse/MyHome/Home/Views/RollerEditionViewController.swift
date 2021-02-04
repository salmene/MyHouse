//
//  RollerEditionViewController.swift
//  MyHome
//
//  Created by Salmen NOUIR on 02/02/2021.
//

import UIKit
import RxSwift
import SnapKit

class RollerEditionViewController: UIViewController {
    
    private let viewModel: RollerEditionViewModel
    private let disposeBag = DisposeBag()
    
    init(_ deviceID: Int) {
        self.viewModel = DefaultRollerEditionViewModel(deviceID: deviceID, manager: DefaultDevicesRepository.sharedInstance)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI Components
    private let backButton = UIButton()
    private let nameLabel = UILabel()
    private let typeIV = UIImageView()
    private let slider = CustomSlider()
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
        typeIV.image = Ressources.Images.rollerShutterIc
        typeIV.tintColor = Ressources.Colors.yellow
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
        
        let sliderContainerView = UIView()
        self.view.addSubview(sliderContainerView)
        sliderContainerView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(230)
        }
        
        slider.minimumTrackTintColor = Ressources.Colors.yellow
        slider.maximumTrackTintColor = Ressources.Colors.mainDarkColor
        slider.minimumValue = 0
        slider.maximumValue = 100
        sliderContainerView.addSubview(slider)
        slider.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        
        slider.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.center.equalToSuperview()
        }
        
        valueLabel.textColor = Ressources.Colors.mainDarkColor
        valueLabel.font = Ressources.Fonts.latoRegular(21)
        valueLabel.textAlignment = .left
        view.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(sliderContainerView.snp.trailing)
            make.centerY.equalTo(sliderContainerView.snp.centerY)
            make.trailing.equalToSuperview()
        }
    }
    
    /**
     Bind & subscribe to viewModel properties
     */
    private func bindToViewModel() {
        viewModel.deviceName.bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.position.map{Float($0)}.bind(to: slider.rx.value)
            .disposed(by: disposeBag)
        
        slider.rx.value.subscribe(onNext: {[weak self] value in
            guard let self = self else {
                return
            }
            self.viewModel.updateRoller(Int(value))
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.subscribe(onNext: {[weak self] () in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.position.subscribe(onNext: {[weak self] intensity in
            self?.valueLabel.text = Ressources.Strings.rollerValue + ": \(intensity)"
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
