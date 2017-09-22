//
//  Box.swift
//  weLearn
//
//  Created by Marty Avedon on 3/12/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit

class Box: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.isOpaque = true
    }
    
    override func layoutSubviews() {
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowColor = UIColor.weLearnBlue.cgColor
        self.layer.shadowOffset = CGSize(width: -2, height: 3)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
