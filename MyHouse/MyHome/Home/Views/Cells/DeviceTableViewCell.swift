//
//  DeviceTableViewCell.swift
//  MyHome
//
//  Created by Salmen NOUIR on 31/01/2021.
//

import UIKit
import SnapKit

class DeviceTableViewCell: UITableViewCell {
    
    var viewModel: DeviceCellViewModel? {
        didSet {
            if let viewModel = viewModel {
                self.typeIV.image = viewModel.image
                self.typeIV.tintColor = (viewModel.isON) ? Ressources.Colors.yellow : Ressources.Colors.mainDarkColor
                nameLabel.text = viewModel.name
                valueLabel.text = viewModel.value
            }
        }
    }
    
    //MARK: UI Components
    private let shadowView = UIView()
    private let mainView = UIView()
    private let typeIV = UIImageView()
    private let nameLabel = UILabel()
    private let valueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    
    /**
     This function initializes UI components
     */
    private func initUI() {
        self.selectionStyle = .none
        self.contentView.addSubview(shadowView)
        shadowView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(13)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-13)
            make.height.equalTo(118)
        }
        shadowView.clipsToBounds = false
        shadowView.layer.masksToBounds = false
        mainView.backgroundColor = Ressources.Colors.white
        self.contentView.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(13)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-13)
            make.height.equalTo(118)
        }
        typeIV.contentMode = .scaleAspectFit
        typeIV.clipsToBounds = true
        mainView.addSubview(typeIV)
        typeIV.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(55)
            make.width.equalTo(55)
        }
        nameLabel.textColor = Ressources.Colors.mainDarkColor
        nameLabel.font = Ressources.Fonts.latoBold(16)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        mainView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(typeIV.snp.trailing).offset(20)
            make.top.equalTo(typeIV.snp.top)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        valueLabel.textColor = Ressources.Colors.mainDarkColor
        valueLabel.font = Ressources.Fonts.latoRegular(12)
        mainView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(typeIV.snp.trailing).offset(20)
            make.bottom.equalTo(typeIV.snp.bottom)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13, *),
           self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            self.shadowView.applyShadow(radius: 6, x: 0, y: 0, color: Ressources.Colors.shadow ?? .lightGray)
            let rect = self.shadowView.bounds
            self.shadowView.layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: 6).cgPath
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.shadowView.applyShadow(radius: 6, x: 0, y: 0, color: Ressources.Colors.shadow ?? .lightGray)
            let rect = self.shadowView.bounds
            self.shadowView.layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: 6).cgPath
        }
        mainView.addCornerRadius(6)
    }
    
}
