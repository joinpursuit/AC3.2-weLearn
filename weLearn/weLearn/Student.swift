//
//  Student.swift
//  weLearn
//
//  Created by Karen Fuentes on 3/9/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation

class Student {
    
    static let manager = Student()
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
    var toDoList: [String]?
    
    static func clearSingleton() {
        var strings = [
            Student.manager.name,
            Student.manager.email,
            Student.manager.id,
            Student.manager.classDatabaseKey,
            Student.manager.image,
            Student.manager.studentKey
        ]
        
        // Clear strings
        for index in 0..<strings.count {
            strings[index] = nil
        }
        
        // Clear the rest
        Student.manager.assignments = nil
        Student.manager.assignmentGrades = nil
        Student.manager.grades = nil
        Student.manager.achievements = nil
    }
    
    static func setAssignmentsReversed(_ assignments: [Assignment]?) {
        if let assign = assignments {
            Student.manager.assignments = assign.reversed()
        }
    }
    
    // Clears the singletons
    static func logOut() {
        Student.clearSingleton()
        MyClass.clearSingleton()
        LessonSchedule.clearSchedule()
    }

}

