//
//  PaddedTextField.swift
//  
//
//  Created by Marty Avedon on 2/27/17.
//
//

import UIKit
import SnapKit

class PaddedTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
//    lazy var stripe: UIView = {
//        let stripe = UIView()
//        stripe.backgroundColor = UIColor.weLearnGreen
//        return stripe
//    }()
//    
//    lazy var bar: UIView = {
//        let bar = UIView()
//        bar.backgroundColor = UIColor.weLearnGreen
//        return bar
//    }()
}
