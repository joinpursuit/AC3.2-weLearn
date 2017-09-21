//
//  AchievementCollectionViewCell.swift
//  weLearn
//
//  Created by Marty Avedon on 3/8/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit

class AchievementCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        self.descriptionLabel.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.descriptionLabel.layer.shadowColor = UIColor.weLearnBlue.cgColor
        self.descriptionLabel.layer.shadowOpacity = 0.33
        self.descriptionLabel.layer.shadowRadius = 3
    }
    
    func setupHierarchy() {
        self.contentView.addSubview(achievementPic)
        self.contentView.addSubview(descriptionLabel)
    }
    
    func setupConstraints() {
        
        contentView.snp.makeConstraints { (view) in
            view.width.height.equalTo(100)
        }
        
        achievementPic.snp.makeConstraints { (pic) in
            pic.top.equalTo(contentView)
            pic.width.height.equalTo(80)
            pic.centerX.equalTo(contentView)
        }
        
        descriptionLabel.snp.makeConstraints { (lbl) in
            lbl.top.equalTo(achievementPic.snp.bottom)
            lbl.leading.trailing.equalTo(contentView)
            lbl.height.equalTo(40)
        }
    }
    
    lazy var achievementPic: UIImageView = {
        let pic = UIImageView()
        pic.layer.cornerRadius = 40
        pic.clipsToBounds = true
        pic.contentMode = .scaleAspectFill
        pic.layer.borderColor = UIColor.weLearnGrey.cgColor
        pic.layer.borderWidth = 5
        return pic
    }()
    
    lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.white
        lbl.isOpaque = true
        lbl.textColor = UIColor.weLearnBlue
        lbl.font = UIFont(name: "Avenir-Black", size: 14)
        lbl.textAlignment = .center
        lbl.numberOfLines = 3
        lbl.lineBreakMode = .byWordWrapping
        lbl.layer.borderColor = UIColor.white.cgColor
        lbl.layer.borderWidth = 5
        return lbl
    }()
    
}

