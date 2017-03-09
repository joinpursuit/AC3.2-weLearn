//
//  Announcement.swift
//  weLearn
//
//  Created by Marty Avedon on 3/3/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation

class Announcement {
    let date: String
    let quote: String
    let author: String
    
    init(quote: String, author: String) {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM dd | h:mm a"
        
        self.date = dateFormatter.string(from: currentDate)
        self.quote = quote
        self.author = author
    }
}
