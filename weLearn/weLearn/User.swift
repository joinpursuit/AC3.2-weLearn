//
//  Student.swift
//  weLearn
//
//  Created by Karen Fuentes on 3/9/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation


class User {
   
    
//    init(name: String, email: String, id: Int?, teacher: Bool, classroom: String?, image: UIImage) {
//        self.name = name
//        self.e           ail = email
//        self.id = id
//        self.teacher = teacher
//        self.classroom = classroom
//        self.image = image
//    }

    static let manager = User()
    private init() {}
    
    var name: String?
    var email: String?
    var id: Int?
    var teacher: Bool?
    var classroom: String?
    var image: String?
}
