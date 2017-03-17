//
//  Student.swift
//  weLearn
//
//  Created by Karen Fuentes on 3/9/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation

class User {
    
    static let manager = User()
    private init() {}
    
    // For temporary, global storage of user info after credentials have been provided
    var name: String?
    var email: String?
    var id: String?
    var classDatabaseKey: String?
    var classroom: String?
    var image: String?
    var studentKey: String? 
    var assignments: [Assignment]?
    var grades: [(assignment: String, grade: String)]?
    var assignmentGrades: [(assignment: String, grade: String)]?
    var agenda: [Agenda]?
    var achievements: [Achievement]?
    
    static func clearSingleton() {
        var strings = [
            User.manager.name,
            User.manager.email,
            User.manager.id,
            User.manager.classDatabaseKey,
            User.manager.image,
            User.manager.studentKey
        ]
        
        // Clear strings
        for index in 0..<strings.count {
            strings[index] = nil
        }
        
        // Clear the rest
        User.manager.assignments = nil
        User.manager.assignmentGrades = nil
        User.manager.grades = nil
        User.manager.achievements = nil
    }
    
    static func setAssignmentsReversed(_ assignments: [Assignment]?) {
        if let assign = assignments {
            User.manager.assignments = assign.reversed()
        }
    }
    
    // Clears the singletons
    static func logOut() {
        User.clearSingleton()
        MyClass.clearSingleton()
        LessonSchedule.clearSchedule()
    }

}

