//
//  AssignmentTableViewCell.swift
//  weLearn
//
//  Created by Marty Avedon on 3/8/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import SnapKit

class AssignmentTableViewCell: UITableViewCell {
    
    var delegate: Tappable?
    var indexPath: IndexPath!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupHierarchy()
        setupConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        assignmentNameLabel.text = ""
        assignmentCountDownLabel.text = ""
        assignmentCountDownLabel.backgroundColor = UIColor.weLearnCoolWhite
    }
    
    // Action
    
    func didClickRepoButton(_ sender: UIButton) {
        if let unwrapDelegate = delegate {
            unwrapDelegate.cellTapped(cell: self)
        }
    }
    
    func setupHierarchy() {
        self.contentView.addSubview(box)
        self.contentView.addSubview(assignmentNameLabel)
   //     self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(topHorizontalRule)
        self.contentView.addSubview(bottomHorizontalRule)
        self.contentView.addSubview(assignmentCountDownLabel)
       // self.contentView.addSubview(gradeLabel)
       // self.contentView.addSubview(repoLink)
    }
    
    func setupConstraints() {
        box.snp.makeConstraints { (view) in
            view.leading.equalTo(contentView).offset(14)
            view.top.equalTo(contentView).offset(14)
            view.trailing.equalTo(contentView).inset(14)
            view.bottom.equalTo(contentView).inset(14)
        }
        
        assignmentNameLabel.snp.makeConstraints { label in
            label.top.leading.equalTo(box).offset(10)
            label.trailing.equalTo(box).inset(10)
        }
        
        assignmentCountDownLabel.snp.makeConstraints { label in
            label.top.equalTo(topHorizontalRule.snp.bottom)
            label.leading.equalTo(box).offset(10)
            label.trailing.equalTo(box).inset(10)
        }
        
//        dateLabel.snp.makeConstraints { label in
//            label.top.equalTo(assignmentNameLabel.snp.bottom).offset(20)
//            label.leading.equalTo(box).offset(10)
//        }
        
//        gradeLabel.snp.makeConstraints { label in
//            label.top.equalTo(topHorizontalRule.snp.bottom)
//            label.centerX.equalTo(box)
//        }
        
//        gradeSquare.snp.makeConstraints { view in
//            view.height.width.equalTo(33)
//            view.centerY.equalTo(dateLabel)
//            view.trailing.equalTo(box).inset(10)
//        }
        
//        repoLink.snp.makeConstraints { view in
//            view.top.equalTo(gradeLabel.snp.bottom).offset(20)
//            view.width.equalTo(box).dividedBy(2)
//            view.height.equalTo(44)
//            view.centerX.equalTo(box)
//            view.bottom.equalTo(box).inset(10)
//        }
        
        topHorizontalRule.snp.makeConstraints { view in
            view.height.equalTo(1)
            view.width.equalTo(box)
            view.centerY.equalTo(assignmentNameLabel.snp.bottom)
            view.centerX.equalTo(box)
        }
        
        bottomHorizontalRule.snp.makeConstraints { view in
            view.height.equalTo(1)
            view.width.equalTo(box)
            view.centerY.equalTo(/*gradeLabel*/assignmentCountDownLabel.snp.bottom)
            view.centerX.equalTo(box)
            view.bottom.equalTo(box).inset(10)
        }
        
    }
    
    lazy var box: Box = {
        let button = Box()
        button.addTarget(self, action: #selector(didClickRepoButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var assignmentNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 24)
        label.numberOfLines = 3
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
//    lazy var dateLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "Avenir-Light", size: 16)
//        return label
//    }()
    
//    lazy var gradeLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.textColor = UIColor.weLearnBlue
//        label.layer.shadowColor = UIColor.weLearnBlue.withAlphaComponent(0.75).cgColor
//        label.font = UIFont(name: "Avenir-Black", size: 36)
//        return label
//    }()
    
    lazy var assignmentCountDownLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.weLearnBlue
        label.font = UIFont(name: "Avenir-Black", size: 30)
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
//    lazy var repoLink: UIButton = {
//        let button = UIButton()
//        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 20)
//        button.setTitleColor(UIColor.white, for: .normal)
//        button.backgroundColor = UIColor.weLearnBlue
//        button.addTarget(self, action: #selector(didClickRepoButton(_:)), for: .touchUpInside)
//        button.layer.shadowOffset = CGSize(width: 0, height: 3)
//        button.layer.shadowOpacity = 0.25
//        button.layer.shadowRadius = 2
//        return button
//    }()
    
    lazy var topHorizontalRule: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.weLearnGrey
        return view
    }()
    
    lazy var bottomHorizontalRule: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.weLearnGrey
        return view
    }()
    
}
