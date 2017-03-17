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
        
        self.backgroundColor = UIColor.weLearnCoolWhite
        self.bulletView.image = tintedBullet
        self.bulletView.tintColor = UIColor.weLearnBlue
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
        lbl.textAlignment = .left
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 3
        return lbl
    }()
    
    lazy var bulletView: UIImageView = {
        let pic = UIImageView()
        pic.contentMode = .center
        return pic
    }()
}
