//
//  Grade.swift
//  weLearn
//
//  Created by Marty Avedon on 3/8/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation

class Grade {
    let assignment: String
    let score: String?
    
    init (assignment: String, score: String?) {
        self.assignment = assignment
        self.score = score ?? "n/a"
    }
}
