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
    
    func setupHierarchy() {
        self.contentView.addSubview(achievementPic)
        self.contentView.addSubview(descriptionLabel)
    }
    
    func setupConstraints() {
        
        achievementPic.snp.makeConstraints { (pic) in
            pic.leading.top.equalTo(contentView)
        }
        
        descriptionLabel.snp.makeConstraints { (lbl) in
            lbl.top.equalTo(achievementPic.snp.bottom).inset(5)
            lbl.bottom.equalTo(contentView)
        }
    }
    
    lazy var achievementPic: UIImageView = {
        let pic = UIImageView()
        return pic
    }()
    
    lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Roman", size: 16)
        lbl.textAlignment = .center
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
}

