//
//  Extension+String.swift
//  weLearn
//
//  Created by Victor Zhong on 3/9/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
