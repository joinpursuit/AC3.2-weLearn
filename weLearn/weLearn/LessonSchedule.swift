//
//  LessonSchedule.swift
//  weLearn
//
//  Created by Victor Zhong on 3/9/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation

class LessonSchedule {
    
    static let manager = LessonSchedule()
    private init() {}
    
    var pastAgenda: [Agenda]?
    var todaysAgenda: Agenda?
    var fullAgendaUpToToday: [Agenda]?
    
    func setAgenda(_ array: [Agenda]) {
        let today = Date()
        
        outer: for entry in array {
            if entry.date > today {
                todaysAgenda = entry
                break outer
            }
        }
        
        let reversedSorted = array.sorted(by: {$0.date > $1.date})
        var tempAgenda = [Agenda]()
        for entry in reversedSorted {
            if today >= entry.date  {
                tempAgenda.append(entry)
            }
        }
        pastAgenda = tempAgenda
        
        fullAgendaUpToToday = [todaysAgenda!] + pastAgenda!
        
        print("\n\n\n\n\nWe have a lesson schedule: \(tempAgenda.count) entries")
    }
    
    static func clearSchedule() {
        LessonSchedule.manager.pastAgenda = nil
        LessonSchedule.manager.todaysAgenda = nil
        LessonSchedule.manager.fullAgendaUpToToday = nil
    }
}
