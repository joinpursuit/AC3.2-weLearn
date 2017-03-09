//
//  Assignment.swift
//  weLearn
//
//  Created by Marty Avedon on 3/8/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation

class Assignment {
    let date: String
    let assignmentTitle: String
    let score: String?
    let url: String?
    
    init(date: String, assignmentTitle: String, score: String?, url: String?) {
        self.date = date
        self.assignmentTitle = assignmentTitle
        self.score = score ?? "n/a"
        self.url = url
    }
}
