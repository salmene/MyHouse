//
//  FilterTypeTableViewCell.swift
//  MyHome
//
//  Created by Salmen NOUIR on 01/02/2021.
//

import UIKit
import SnapKit

class FilterTypeTableViewCell: UITableViewCell {
    
    var data: (ObjectType, Bool)? {
        didSet {
            if let data = data {
                if data.1 {
                    self.checkIV.image = UIImage.checkmark
                } else {
                    self.checkIV.image = nil
                }
                switch data.0 {
                case .light:
                    titleLabel.text = Ressources.Strings.lightName.uppercased()
                case .heater:
                    titleLabel.text = Ressources.Strings.heaterName.uppercased()
                case .rollerShutter:
                    titleLabel.text = Ressources.Strings.rollerName.uppercased()
                }
            }
        }
    }
    
    //MARK: UI Components
    private let titleLabel = UILabel()
    private let checkIV = UIImageView()

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
        titleLabel.textColor = Ressources.Colors.mainDarkColor
        titleLabel.font = Ressources.Fonts.latoRegular(16)
        titleLabel.textAlignment = .left
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
        checkIV.contentMode = .scaleAspectFit
        checkIV.clipsToBounds = true
        checkIV.tintColor = Ressources.Colors.yellow
        self.contentView.addSubview(checkIV)
        checkIV.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(25)
            make.width.equalTo(30)
        }
    }

}
