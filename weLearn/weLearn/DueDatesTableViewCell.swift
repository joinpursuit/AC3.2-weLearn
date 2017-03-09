//
//  DueDatesTableViewCell.swift
//  weLearn
//
//  Created by Cris on 3/1/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import SnapKit

class DueDatesTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupHierarchy() {
        self.contentView.addSubview(box)
        self.contentView.addSubview(timerLabel)
        self.contentView.addSubview(assignmentLabel)
    }
    
    func setupConstraints() {
        box.snp.makeConstraints { (view) in
            view.leading.equalTo(contentView).offset(7)
            view.top.equalTo(contentView).offset(7)
            view.trailing.equalTo(contentView).inset(7)
            view.bottom.equalTo(contentView).inset(7)
        }
        
        timerLabel.snp.makeConstraints { (lbl) in
            lbl.leading.equalTo(contentView).offset(10)
            lbl.trailing.equalTo(contentView).inset(10)
            lbl.top.equalTo(contentView).offset(13)
            lbl.bottom.equalTo(assignmentLabel.snp.top).inset(-5)
        }
        
        assignmentLabel.snp.makeConstraints { (lbl) in
            lbl.leading.equalTo(contentView).offset(10)
            lbl.trailing.equalTo(contentView).inset(10)
            lbl.bottom.equalTo(contentView).inset(13)
        }
    }

    lazy var box: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: -2, height: 3)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 3
        view.layer.masksToBounds = false
        return view
    }()
    
    lazy var timerLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Thirtysix", size: 36)
        lbl.textColor = UIColor.weLearnGreen
        lbl.textAlignment = .center
        lbl.layer.shadowColor = UIColor.weLearnBlack.cgColor
        lbl.layer.shadowOffset = CGSize(width: -2, height: 3)
        lbl.layer.shadowOpacity = 3
        lbl.layer.shadowRadius = 1
        lbl.layer.masksToBounds = false
        lbl.numberOfLines = 1
        return lbl
    }()
    
    lazy var assignmentLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Black", size: 24)
        lbl.textColor = UIColor.weLearnGreen
        lbl.textAlignment = .center
        lbl.layer.masksToBounds = false
        return lbl
    }()
}
