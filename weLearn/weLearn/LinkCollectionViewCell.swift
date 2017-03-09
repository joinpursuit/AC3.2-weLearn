//
//  LinkCollectionViewCell.swift
//  weLearn
//
//  Created by Marty Avedon on 3/4/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit

class LinkCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupHierarchy() {
        self.contentView.addSubview(box)
        self.contentView.addSubview(previewPic)
        self.contentView.addSubview(descriptionLabel)
    }
    
    func setupConstraints() {
        box.snp.makeConstraints { (view) in
            view.leading.equalTo(contentView).offset(7)
            view.top.equalTo(contentView).offset(7)
            view.trailing.equalTo(contentView).inset(7)
            view.bottom.equalTo(contentView).inset(7)
        }
        
        previewPic.snp.makeConstraints { (pic) in
            pic.leading.top.equalTo(contentView).offset(10)
            pic.trailing.equalTo(contentView).inset(10)
            pic.bottom.equalTo(contentView).inset(13)
        }
        
        descriptionLabel.snp.makeConstraints { (lbl) in
            lbl.leading.equalTo(contentView).offset(10)
            lbl.trailing.equalTo(contentView).inset(10)
            lbl.bottom.equalTo(contentView).inset(13)
        }
    }
    
    lazy var box: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: -2, height: 3)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 3
        view.layer.masksToBounds = false
        return view
    }()
    
    lazy var previewPic: UIImageView = {
        let pic = UIImageView()
        return pic
    }()
    
    lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.layer.backgroundColor = UIColor.black.withAlphaComponent(0.75).cgColor
        lbl.font = UIFont(name: "Avenir-Light", size: 16)
        lbl.textColor = UIColor.weLearnCoolWhite
        lbl.textAlignment = .center
        lbl.lineBreakMode = .byWordWrapping
        lbl.layer.masksToBounds = false
        return lbl
    }()
}
