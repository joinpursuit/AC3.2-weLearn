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
        self.bulletView.image = tintedBullet
        self.bulletView.tintColor = UIColor.weLearnGreen
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
            pic.leading.equalToSuperview()
            pic.centerY.equalToSuperview()
        }
        
        label.snp.makeConstraints { (lbl) in
            lbl.leading.equalTo(bulletView.snp.trailing)
            lbl.centerY.equalToSuperview()
        }
    }
    
    lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var bulletView: UIImageView = {
        let pic = UIImageView()
        return pic
    }()
}
