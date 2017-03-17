//
//  Classes.swift
//  weLearn
//
//  Created by Victor Zhong on 3/16/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation
import Firebase

enum ClassFromSheetModelParseError: Error {
    case results, parsingResults
}

class ClassFromSheet {
    let className: String
    let studentGradesID: String?
    let assignmentsID: String?
    let lessonScheduleID: String?
    let achievementsID: String?
    let announcementsID: String?
    let gradeBookID: String?
    
    init(className: String,
         studentGradesID: String?,
         assignmentsID: String?,
         lessonScheduleID: String?,
         achievementsID: String?,
         announcementsID: String?,
         gradeBookID: String?) {
        self.className = className
        self.studentGradesID = studentGradesID
        self.assignmentsID = assignmentsID
        self.lessonScheduleID = lessonScheduleID
        self.achievementsID = achievementsID
        self.announcementsID = announcementsID
        self.gradeBookID = gradeBookID
    }
    
    convenience init?(from dict: [String : Any]) throws {
        guard let titleField = dict["title"] as? [String : Any],
            let className = titleField["$t"] as? String,
            let contentField = dict["content"] as? [String : Any],
            let contentString = contentField["$t"] as? String else {
                throw ClassFromSheetModelParseError.parsingResults
        }
        
        let dict = parseString(contentString)
        
        self.init(className: className,
                  studentGradesID: dict["studentgradesid"],
                  assignmentsID: dict["assignmentsid"],
                  lessonScheduleID: dict["lessonscheduleid"],
                  achievementsID: dict["achievementsid"],
                  announcementsID: dict["announcementsid"],
                  gradeBookID: dict["gradebookid"]
                  )
    }
    
    static func getClasses(from data: Data) -> [ClassFromSheet]? {
        var classesParsed: [ClassFromSheet]? = []
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let result = jsonData as? [String : Any],
                let feed = result["feed"] as? [String : Any],
                let entries = feed["entry"] as? [[String : Any]] else {
                    throw ClassFromSheetModelParseError.results
            }
            
            for entry in entries {
                if let classDict = try ClassFromSheet(from: entry) {
                    classesParsed?.append(classDict)
                }
            }
        }
            
        catch {
            print("You got an error: \(error)")
        }
        
        return classesParsed
    }
    
    static func postClassInfoToDatabase(_ classes: [ClassFromSheet]) {
        let classBuckets = FIRDatabase.database().reference().child("classes")
        var classDict: [String : String] = [:]
        
        // Populate classDict with [name : databaseKey] values
        classBuckets.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                if let snap = child as? FIRDataSnapshot, let valueDict = snap.value as? [String : Any] {
                    if let name = valueDict["name"] as? String {
                        classDict[name] = snap.key
                    }
                }
            }
            
            DispatchQueue.main.async {
                for element in classes {
                    let classInfo = [
                        "name" : element.className,
                        "studentGradesID" : element.studentGradesID,
                        "assignmentsID" : element.assignmentsID,
                        "lessonScheduleID" : element.lessonScheduleID,
                        "announcementsID" : element.announcementsID,
                        "gradeBookID" : element.gradeBookID,
                        "achievementsID" : element.achievementsID
                    ]
                    
                    if classDict.keys.contains(element.className) {
                        let thisClassRef = classBuckets.child(classDict[element.className]!)
                        thisClassRef.setValue(classInfo)
                    }
                    else {
                        let newClassRef = classBuckets.childByAutoId()
                        
                        newClassRef.setValue(classInfo)
                    }
                }
            }
        })
    }
}

private func parseString(_ string: String) -> [String : String] {
    var dict = [String:String]()
    
    let weirdArr = string.components(separatedBy: ", ")
    
    for all in weirdArr {
        let this = all.components(separatedBy: ": ")
        dict[this[0]] = this[1]
    }
    
    return dict
}
