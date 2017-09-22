//
//  AssignmentGrades.swift
//  weLearn
//
//  Created by Victor Zhong on 3/16/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation

enum AssignmentGradeModelParseError: Error {
    case results, parsingResults
}

class AssignmentGrade {
    let id: String
    let grades: String
    
    init (id: String, grades: String) {
        self.id = id
        self.grades = grades
    }
    
    convenience init?(from dict: [String:Any]) throws {
        guard let titleField = dict["title"] as? [String : Any],
            let id = titleField["$t"] as? String,
            let contentField = dict["content"] as? [String : Any],
            let contentString = contentField["$t"] as? String else {
                throw AssignmentGradeModelParseError.parsingResults
        }
        
        self.init(id: id, grades: contentString)
    }
    
    static func getAssignmentGrade(from data: Data) -> [AssignmentGrade]? {
        var grades: [AssignmentGrade]? = []
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let result = jsonData as? [String : Any],
                let feed = result["feed"] as? [String : Any],
                let entries = feed["entry"] as? [[String : Any]] else {
                    throw AssignmentGradeModelParseError.results
            }
            
            for entry in entries {
                if let gradesDict = try AssignmentGrade(from: entry) {
                    grades?.append(gradesDict)
                }
            }
        }
            
        catch {
            print("You got an error: \(error)")
        }
        
        return grades
    }
    
    static func getStudentAssignmentGrade(from data: Data, for studentID: String) -> AssignmentGrade? {
        let entries = getAssignmentGrade(from: data)
        
        for entry in entries! where entry.id == studentID {
            return entry
        }
        
        return nil
    }
    
    static func parseGradeString(_ string: String) -> [(assignment: String, grade: String)] {
        var returnArray = [(assignment: String, grade: String)]()
        
        let weirdArr = string.components(separatedBy: ", ")
        
        for all in weirdArr {
            let this = all.components(separatedBy: ": ")
            if this[0] != "name" {
                
                returnArray.append((assignment: removeHypensAndCapitalize(this[0]), grade: this[1]))
            }
        }
        
        return returnArray
    }
    
    static func removeHypensAndCapitalize(_ string: String) -> String {
        let stringArray = string.components(separatedBy: "-")
        var returnString = ""
        for word in stringArray {
            returnString += "\(word.capitalizingFirstLetter()) "
        }
        return returnString
    }
}
