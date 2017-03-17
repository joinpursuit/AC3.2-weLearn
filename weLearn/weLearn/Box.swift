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
        
        self.backgroundColor = UIColor.weLearnCoolWhite
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: -2, height: 3)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
