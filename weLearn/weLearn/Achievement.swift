//
//  Achievement.swift
//  weLearn
//
//  Created by Marty Avedon on 3/8/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation

enum AchievementModelParseError: Error {
    case results, parsingResults
}

class Achievement {
    let pic: String
    let description: String
    
    init (description: String) {
        self.pic = randomPic()
        self.description = description
    }
}

class AchievementBucket {
    let id: String
    let contentString: String
    
    init(id: String, contentString: String) {
        self.id = id
        self.contentString = contentString
    }
    
    convenience init?(from dict: [String:Any]) throws {
        guard let titleField = dict["title"] as? [String : Any],
            let id = titleField["$t"] as? String,
            let contentField = dict["content"] as? [String : Any],
            let contentString = contentField["$t"] as? String else {
                throw AchievementModelParseError.parsingResults
        }
        
        self.init(id: id, contentString: contentString)
    }
    
    static func getAchievementBucket(from data: Data) -> [AchievementBucket]? {
        var bucket: [AchievementBucket]? = []
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let result = jsonData as? [String : Any],
                let feed = result["feed"] as? [String : Any],
                let entries = feed["entry"] as? [[String : Any]] else {
                    throw AchievementModelParseError.results
            }
            
            for entry in entries {
                if let chievoDict = try AchievementBucket(from: entry) {
                    bucket?.append(chievoDict)
                }
            }
        }
        
        catch {
            print("You got an error: \(error)")
        }
        
        return bucket
    }
    
    static func getStudentAchievementBucket(from data: Data, for studentID: String) -> AchievementBucket? {
        let entries = getAchievementBucket(from: data)
        
        for entry in entries! where entry.id == studentID {
            return entry
        }
        
        return nil
    }
    
    
    static func parseBucketString(_ string: String) -> [Achievement] {
        var returnArray = [Achievement]()
        
        let weirdArr = string.components(separatedBy: ", ")
        
        for all in weirdArr {
            let this = all.components(separatedBy: ": ")
            if this[0] != "name" {
                returnArray.append(Achievement(description: removeHypensAndCapitalize(this[0])))
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


func randomPic() -> String {
    let picArray = [
        "academicExcellence",
        "studentOfTheMonth"
    ]
    
    return picArray[Int(arc4random_uniform(UInt32(picArray.count)))]
}
