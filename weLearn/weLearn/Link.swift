//
//  Link.swift
//  weLearn
//
//  Created by Marty Avedon on 3/4/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation

// *** Work in Progress!!

class Link {
    var url: String
    var previewPic: String
    var description: String
    
    // meta data - this way we track who made what link, and when
    var author: String
    var date: String
    
    init(url: String, description: String) {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "mm/dd/yy hh:mm:ss"

        self.previewPic = "" // we have to make an api call here to get the image from the website...
        self.description = description
        self.url = url
        self.author = "" // the user who is creating it's name
        self.date = dateFormatter.string(from: currentDate)
    }
    
    func blame() {
        print("I was made by \(self.author) at \(self.date)")
    }
}
