//
//  LinkTableViewCell.swift
//  weLearn
//
//  Created by Marty Avedon on 3/9/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit

class LinkTableViewCell: UITableViewCell {
    
    var delegate: Tappable?
    var indexPath: IndexPath!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupHierarchy()
        setupConstraints()
        
        self.backgroundColor = UIColor.weLearnBlue

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // Action
    
    func didClickUrlButton(_ sender: UIButton) {
        if let unwrapDelegate = delegate {
            unwrapDelegate.cellTapped(cell: self)
        }
    }
    
    func setupHierarchy() {
        self.contentView.addSubview(box)
        self.contentView.addSubview(authorLabel)
        self.contentView.addSubview(descriptionLabel)
    }
    
    func setupConstraints() {
        box.snp.makeConstraints { view in
            view.leading.top.equalTo(contentView).offset(14)
            view.trailing.bottom.equalTo(contentView).inset(14)
        }
        
        authorLabel.snp.makeConstraints { (view) in
            view.top.leading.equalTo(box).offset(10)
        }
        
        descriptionLabel.snp.makeConstraints { (lbl) in
            lbl.top.equalTo(authorLabel.snp.bottom)
            lbl.leading.equalTo(box).offset(10)
            lbl.trailing.equalTo(box).inset(10)
            lbl.bottom.equalTo(contentView).inset(20)
        }
    }
    
    lazy var box: Box = {
        let button = Box()
        button.addTarget(self, action: #selector(didClickUrlButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.weLearnBlue
        lbl.font = UIFont(name: "Avenir-Black", size: 24)
        lbl.textAlignment = .center
        lbl.numberOfLines = 5
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    lazy var authorLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.darkGray
        lbl.font = UIFont(name: "Avenir-Heavy", size: 16)
        return lbl
    }()

}
