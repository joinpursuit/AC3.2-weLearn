//
//  AgenTableViewCell.swift
//  weLearn
//
//  Created by Cris on 3/1/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import SnapKit

class AgenTableViewCell: UITableViewCell {

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
        self.contentView.addSubview(label)
    }
    
    func setupConstraints() {
        label.snp.makeConstraints { (lbl) in
            lbl.leading.trailing.equalToSuperview()
            lbl.centerY.equalToSuperview()
            //            lbl.height.equalToSuperview()
        }
    }
    
    lazy var label: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
}
