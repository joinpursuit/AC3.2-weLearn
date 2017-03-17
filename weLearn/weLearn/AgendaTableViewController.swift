//
//  AgendaTableViewController.swift
//  weLearn
//
//  Created by Karen Fuentes on 3/8/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//
import UIKit
import SafariServices
import FirebaseAuth

class AgendaTableViewController: UITableViewController {
    //    var todaysFakeSchedule: [String] = [
    //        "DSA",
    //        "Sprite Kit with Louis",
    //        "Capstone",
    //        "Lunch break",
    //        "Talk to Tech Mentors",
    //        "Workshop at Headquarters"
    //    ]
    
    let agendaSheetID = MyClass.manager.lessonScheduleID!
    let assignmentSheetID = MyClass.manager.assignmentsID!
    var todaysAgenda: Agenda?
    
    var agenda: [Agenda]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Syllabus"
        self.tabBarController?.title = navigationItem.title
        
        tableView.register(AgendaTableViewCell.self, forCellReuseIdentifier: "AgendaTableViewCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 268.0
        
        readAgenda()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    // MARK: - Agenda functions
    
    func todaysSchedule() -> Agenda? {
        if let agenda = agenda {
            LessonSchedule.manager.setAgenda(agenda)
            if let agendaception = LessonSchedule.manager.pastAgenda {
                return agendaception[0]
            }
        }
        return nil
    }
    
    func readAgenda() {
        if LessonSchedule.manager.pastAgenda == nil {
            APIRequestManager.manager.getData(endPoint: "https://spreadsheets.google.com/feeds/list/\(agendaSheetID)/od6/public/basic?alt=json") { (data: Data?) in
                if data != nil {
                    if let returnedAgenda = Agenda.getAgenda(from: data!) {
                        print("We've got returns: \(returnedAgenda.count)")
                        self.agenda = returnedAgenda
                        DispatchQueue.main.async {
                            self.todaysAgenda = self.todaysSchedule()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        else {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Button Actions
    
    func logOutButtonWasPressed(selector: UIButton) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                self.navigationController?.navigationBar.isHidden = true
                selector.isHidden = true
                self.dismiss(animated: true, completion: nil)
            }
                
            catch {
                print(error)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.weLearnBlue
        header.textLabel?.font = UIFont(name: "Avenir-Light", size: 30)
        header.textLabel?.textAlignment = .center
        header.textLabel?.adjustsFontSizeToFitWidth = true
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            //        case 0:
        //            return "March 10, 2017"
        case 0:
            if agenda != nil {
                return "Today's Agenda"
            }
        case 1:
            if agenda != nil {
                return "Past Agenda"
            }
            else {
                return nil
            }
        default:
            return ""
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            if LessonSchedule.manager.todaysAgenda != nil {
                return 1
            }
        case 1:
            if let agenda = LessonSchedule.manager.pastAgenda {
                return agenda.count
            }
            
        default:
            break
            
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AgendaTableViewCell", for: indexPath) as! AgendaTableViewCell
        
        // needs diff sections
        
        switch indexPath.section {
        case 0:
            if let agenda = LessonSchedule.manager.todaysAgenda {
                cell.label.text = agenda.lessonName
            }
        case 1:
            if let agenda = LessonSchedule.manager.pastAgenda {
                let agendaAtRow = agenda[indexPath.row]
                cell.label.text = "\(agendaAtRow.dateString) - \(agendaAtRow.lessonName)"
            }
        default:
            break
            
        }
        return cell
    }
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        if let url = agenda[indexPath.row].repoURL {
    //
    //            let svc = SFSafariViewController(url: URL(string: url)!)
    //            present(svc, animated: true, completion: nil)
    //        }
    //
    //    }
}
