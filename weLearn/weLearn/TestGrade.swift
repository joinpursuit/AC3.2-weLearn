//
//  TestGrade.swift
//  weLearn
//
//  Created by Victor Zhong on 3/8/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation

enum TestGradeModelParseError: Error {
    case results, parsingResults
}

class TestGrade {
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
                throw TestGradeModelParseError.parsingResults
        }
        
        self.init(id: id, grades: contentString)
    }
    
    static func getTestGrade(from data: Data) -> [TestGrade]? {
        var grades: [TestGrade]? = []
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let result = jsonData as? [String : Any],
                let feed = result["feed"] as? [String : Any],
                let entries = feed["entry"] as? [[String : Any]] else {
                    throw TestGradeModelParseError.results
            }
            
            for entry in entries {
                if let gradesDict = try TestGrade(from: entry) {
                    grades?.append(gradesDict)
                }
            }
        }
            
        catch {
            print("You got an error: \(error)")
        }
        
        return grades
    }
    
    static func getStudentTestGrade(from data: Data, for studentID: String) -> TestGrade? {
        let entries = getTestGrade(from: data)
        
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
}

func removeHypensAndCapitalize(_ string: String) -> String {
    let stringArray = string.components(separatedBy: "-")
    var returnString = ""
    for word in stringArray {
        returnString += "\(word.capitalizingFirstLetter()) "
    }
    return returnString
}



