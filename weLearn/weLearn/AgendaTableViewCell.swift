//
//  AgendaTableViewCell.swift
//  weLearn
//
//  Created by Cris on 3/1/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import SnapKit

class AgendaTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupHierarchy()
        setupConstraints()
        
        let plainBullet = #imageLiteral(resourceName: "bullet")
        let tintedBullet = plainBullet.withRenderingMode(.alwaysTemplate)
        
        self.backgroundColor = UIColor.white
        self.isOpaque = true

        self.bulletView.image = tintedBullet
        self.bulletView.tintColor = UIColor.weLearnBrightBlue
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        self.backgroundColor = UIColor.white
        self.label.font = UIFont(name: "Avenir-Roman", size: 20)
        self.bulletView.isHidden = false
        self.bulletView.tintColor = UIColor.weLearnBrightBlue
        self.label.text = "M/DD/YY - Lesson Name"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            self.backgroundColor = UIColor.weLearnCoolWhite
            self.label.backgroundColor = UIColor.weLearnCoolWhite
            self.bulletView.backgroundColor = UIColor.weLearnCoolWhite
        } else {
            self.backgroundColor = UIColor.white
            self.label.backgroundColor = UIColor.white
            self.bulletView.backgroundColor = UIColor.white
        }
    }
    
    
    
    func setupHierarchy() {
        self.contentView.addSubview(bulletView)
        self.contentView.addSubview(label)
    }
    
    func setupConstraints() {
        bulletView.snp.makeConstraints { (pic) in
            pic.leading.equalTo(contentView)
            pic.width.equalTo(20)
            pic.centerY.equalTo(contentView)
        }
        
        label.snp.makeConstraints { (lbl) in
            lbl.leading.equalTo(bulletView.snp.trailing)
            lbl.trailing.equalTo(contentView).offset(10)
            lbl.top.equalTo(contentView).offset(7)
            lbl.bottom.equalTo(contentView).inset(7)
        }
    }
    
    lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Roman", size: 20)
        lbl.textAlignment = .left
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 3
        lbl.backgroundColor = UIColor.white
        lbl.isOpaque = true
        return lbl
    }()
    
    lazy var bulletView: UIImageView = {
        let pic = UIImageView()
        pic.contentMode = .center
        pic.isOpaque = true

        return pic
    }()
}
