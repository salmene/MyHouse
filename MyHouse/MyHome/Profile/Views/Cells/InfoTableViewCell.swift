//
//  InfoTableViewCell.swift
//  MyHome
//
//  Created by Salmen NOUIR on 03/02/2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class InfoTableViewCell: UITableViewCell {

    var data: (UserInfo, String?)? {
        didSet {
            if let data = data {
                titleLabel.text = data.0.getTitle() + ":"
                valueLabel.text = data.1
            }
        }
    }
    var editBtnAction: ((UserInfo)->Void)?
    private let disposeBag = DisposeBag()
    
    //MARK: UI Components
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let editBtn = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        setButtonAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
        setButtonAction()
    }
    
    /**
     This function initializes UI components
     */
    private func initUI() {
        self.selectionStyle = .none
        titleLabel.textColor = Ressources.Colors.mainDarkColor
        titleLabel.font = Ressources.Fonts.latoBold(20)
        titleLabel.textAlignment = .left
        self.contentView.addSubview(editBtn)
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
        }
        valueLabel.textColor = Ressources.Colors.mainDarkColor
        valueLabel.font = Ressources.Fonts.latoRegular(18)
        valueLabel.textAlignment = .left
        valueLabel.numberOfLines = 0
        self.contentView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.trailing.equalTo(editBtn.snp.leading).offset(-8)
            make.bottom.equalToSuperview().offset(-15)
        }
        editBtn.setImage(Ressources.Images.editIc, for: .normal)
        editBtn.tintColor = Ressources.Colors.yellow
        editBtn.contentMode = .scaleAspectFit
        editBtn.clipsToBounds = true
        editBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(28)
            make.width.equalTo(28)
        }
    }
    
    /**
     This function defines the edit button's action
     */
    private func setButtonAction() {
        editBtn.rx.tap.subscribe(onNext: {[weak self] in
            guard let infoType = self?.data?.0 else {
                return
            }
            self?.editBtnAction?(infoType)
        }).disposed(by: disposeBag)
    }

}
