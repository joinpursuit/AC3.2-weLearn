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

        self.backgroundColor = UIColor.weLearnBrightBlue
        self.isOpaque = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        authorLabel.text = ""
        descriptionLabel.text = ""
        let defaultPic = #imageLiteral(resourceName: "user")
        let tintedDefault = defaultPic.withRenderingMode(.alwaysTemplate)
        profilePic.tintColor = UIColor.weLearnBlue
        profilePic.image = tintedDefault
        profilePic.backgroundColor = UIColor.black
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
        self.contentView.addSubview(profilePic)
    }
    
    func setupConstraints() {
        box.snp.makeConstraints { view in
            view.leading.top.equalTo(contentView).offset(14)
            view.trailing.bottom.equalTo(contentView).inset(14)
        }
        
        profilePic.snp.makeConstraints { (view) in
            view.top.equalTo(box).offset(10)
            view.leading.equalTo(box).offset(10)
            view.width.height.equalTo(50)
        }
        
        authorLabel.snp.makeConstraints { (view) in
            view.centerY.equalTo(profilePic)
            view.leading.equalTo(profilePic.snp.trailing).offset(5)
            view.trailing.equalTo(box)
            view.width.equalTo(300)
        }
        
        descriptionLabel.snp.makeConstraints { (lbl) in
            lbl.top.equalTo(profilePic.snp.bottom).offset(10)
            lbl.leading.equalTo(box).offset(30)
            lbl.trailing.equalTo(box).inset(30)
            lbl.bottom.equalTo(box).inset(10)
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
        lbl.textAlignment = .left
        lbl.numberOfLines = 10
        lbl.lineBreakMode = .byWordWrapping
        lbl.backgroundColor = UIColor.weLearnCoolWhite
        lbl.isOpaque = true
        return lbl
    }()
    
    lazy var authorLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.darkGray
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.backgroundColor = UIColor.weLearnCoolWhite
        lbl.isOpaque = true
        return lbl
    }()
    
    lazy var profilePic: UIImageView = {
        let pic = UIImageView()
        pic.clipsToBounds = true
        pic.layer.cornerRadius = 25
        pic.layer.borderColor = UIColor.weLearnBlue.cgColor
        let defaultPic = #imageLiteral(resourceName: "user")
        let tintedDefault = defaultPic.withRenderingMode(.alwaysTemplate)
        pic.tintColor = UIColor.weLearnBlue
        pic.image = tintedDefault
        pic.backgroundColor = UIColor.black
        pic.contentMode = .scaleAspectFill
        pic.layer.borderWidth = 3
        pic.isOpaque = true
        return pic
    }()
}
