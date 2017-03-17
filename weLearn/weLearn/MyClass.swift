//
//  MyClass.swift
//  weLearn
//
//  Created by Victor Zhong on 3/16/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation

class MyClass {
    
    static let manager = MyClass()
    private init() {}
    
    var studentGradesID: String?
    var assignmentsID: String?
    var lessonScheduleID: String?
    var announcementsID: String?
    var gradeBookID: String?
    var achievementsID: String?
    
    static func clearSingleton() {
        var strings = [
            MyClass.manager.studentGradesID,
            MyClass.manager.assignmentsID,
            MyClass.manager.lessonScheduleID,
            MyClass.manager.announcementsID,
            MyClass.manager.achievementsID,
            MyClass.manager.gradeBookID
        ]
        
        // Clear strings
        for index in 0..<strings.count {
            strings[index] = nil
        }
    }
}
