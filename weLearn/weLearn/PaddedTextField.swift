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
    var stripe: UIView!
    var bar: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.stripe = UIView()
        self.bar = UIView()
        
        self.addSubview(stripe)
        self.addSubview(bar)
        
            stripe.snp.makeConstraints { view in
                view.width.equalToSuperview()
                view.trailing.equalToSuperview()
                view.height.equalTo(2)
                view.bottom.equalToSuperview().offset(2)
            }
            
            bar.snp.makeConstraints { view in
                view.top.equalToSuperview()
                view.bottom.equalToSuperview()
                view.width.equalTo(2)
                view.leading.equalToSuperview()
            }
            
            stripe.backgroundColor = UIColor.weLearnBlue
            bar.backgroundColor = UIColor.weLearnBlue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
}
