//
//  GradeTableViewCell.swift
//  weLearn
//
//  Created by Marty Avedon on 3/8/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import SnapKit

class GradeTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupHierarchy()
        setupConstraints()
        
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        testNameLabel.font = UIFont(name: "Avenir-Roman", size: 16)
        
        super.prepareForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupHierarchy() {
        self.contentView.addSubview(testNameLabel)
        self.contentView.addSubview(gradeSquare)
        self.contentView.addSubview(gradeLabel)
    }
    
    func setupConstraints() {
        testNameLabel.snp.makeConstraints { label in
            label.leading.equalTo(contentView).offset(20)
            label.centerY.equalTo(contentView)
        }
        
        gradeLabel.snp.makeConstraints { label in
            label.center.equalTo(gradeSquare)
        }
        
        gradeSquare.snp.makeConstraints { view in
            view.height.width.equalTo(contentView.snp.height)
            view.trailing.equalTo(contentView).inset(5)
        }
    }
    
    lazy var testNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Roman", size: 16)
        return label
    }()
    
    lazy var gradeSquare: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.weLearnGrey.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var gradeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir-Black", size: 16)
        return label
    }()

}
