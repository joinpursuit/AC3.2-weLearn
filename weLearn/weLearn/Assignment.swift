//
//  Assignment.swift
//  weLearn
//
//  Created by Marty Avedon on 3/8/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation

enum AssignmentModelParseError: Error {
    case results, parsingResults
}

class Assignment {
    let assignmentTitle: String
    let date: Date
    //    let score: String?
    let url: String?
    
    init(assignmentTitle: String, date: Date, url: String?) {
        self.assignmentTitle = assignmentTitle
        self.date = date
        self.url = url
    }
    
    convenience init?(from dict: [String:Any]) throws {
        guard let titleField = dict["title"] as? [String : Any],
            let assignmentName = titleField["$t"] as? String,
            let contentField = dict["content"] as? [String : Any],
            let contentString = contentField["$t"] as? String else {
                
                throw AgendaModelParseError.parsingResults
        }
        
        let dict = parseString(contentString)
        
        self.init(assignmentTitle: assignmentName,
                  date: dateConvert(dict["duedate"]!),
                  url: dict["link"])
    }
    
    static func getAssignment(from data: Data) -> [Assignment]? {
        var assignment: [Assignment]? = []
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let result = jsonData as? [String : Any],
                let feed = result["feed"] as? [String : Any],
                let entries = feed["entry"] as? [[String : Any]] else {
                    throw AssignmentModelParseError.results
            }
            
            for entry in entries {
                if let assignmentDict = try Assignment(from: entry) {
                    assignment?.append(assignmentDict)
                }
            }
        }
            
        catch {
            print("You got an error: \(error)")
        }
        
        return assignment
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

private func dateConvert(_ string: String) -> Date {
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "MM/dd/yy'T'HH:mmZZZZZ"
    let dateString = "\(string)T10:00-04:00"
    return dateformatter.date(from: dateString)!
}
