//
//  Announcement.swift
//  weLearn
//
//  Created by Marty Avedon on 3/3/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation

enum AnnouncementModelParseError: Error {
    case results, parsingResults
}

class Announcement {
    let date: Date
    let dateString: String
    let quote: String
    let author: String
    
    init(date: Date, dateString: String, quote: String, author: String) {
        self.date = date
        self.dateString = dateString
        self.quote = quote
        self.author = author
    }

    convenience init?(from dict: [String:Any]) throws {
        guard let titleField = dict["title"] as? [String : Any],
            let author = titleField["$t"] as? String,
            let contentField = dict["content"] as? [String : Any],
            let contentString = contentField["$t"] as? String else {
                
                throw AgendaModelParseError.parsingResults
        }
        
        let dict = parseString(contentString)
        
        self.init(date: dateConvert(dict["date"]!), dateString: dict["date"]!, quote: dict["message"]!, author: author)
    }
    
    static func getAnnouncements(from data: Data) -> [Announcement]? {
        var announcements: [Announcement]? = []
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let result = jsonData as? [String : Any],
                let feed = result["feed"] as? [String : Any],
                let entries = feed["entry"] as? [[String : Any]] else {
                    throw AnnouncementModelParseError.results
            }
            
            for entry in entries {
                if let announcementDict = try Announcement(from: entry) {
                    announcements?.append(announcementDict)
                }
            }
        }
            
        catch {
            print("You got an error: \(error)")
        }
        
        return announcements
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
    dateformatter.dateFormat = "MM/dd/yy"
    return dateformatter.date(from: string)!
}
