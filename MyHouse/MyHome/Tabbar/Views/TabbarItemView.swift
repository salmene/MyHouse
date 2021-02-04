//
//  TabbarItemView.swift
//  MyHome
//
//  Created by Salmen NOUIR on 31/01/2021.
//

import UIKit
import SnapKit
import RxSwift

class TabbarItemView: UIView {
    
    let item: TabItem
    var selectionAction: ((TabItem)->Void)?
    private let disposeBag = DisposeBag()
    
    //MARK: UI Components
    private let iconIV = UIImageView()
    private let titleLabel = UILabel()
    private let selectionView = UIView()
    private let button = UIButton()
    
    init(frame: CGRect, item: TabItem) {
        self.item = item
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     This function initializes UI components
     */
    private func initUI() {
        iconIV.image = item.getIcon()
        iconIV.clipsToBounds = true
        iconIV.contentMode = .scaleAspectFit
        self.addSubview(iconIV)
        iconIV.snp.makeConstraints {[unowned self] (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
            make.height.equalTo(self.bounds.height / 3)
        }
        titleLabel.text = item.getTitle()
        titleLabel.textColor = Ressources.Colors.mainDarkColor
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconIV.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        self.addSubview(selectionView)
        selectionView.backgroundColor = Ressources.Colors.yellow
        selectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalToSuperview().dividedBy(2)
        }
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        button.rx.tap.subscribe(onNext: {[weak self] () in
            self?.selectionAction?(self?.item ?? .home)
        }).disposed(by: disposeBag)
    }
    
    /**
     This function allows to update appearance according to selection status
     */
    func setSelected(_ selected: Bool) {
        if selected {
            titleLabel.font = Ressources.Fonts.latoBold(14)
            selectionView.isHidden = false
            iconIV.tintColor = Ressources.Colors.yellow
        } else {
            titleLabel.font = Ressources.Fonts.latoRegular(14)
            selectionView.isHidden = true
            iconIV.tintColor = Ressources.Colors.mainDarkColor
        }
    }
}
