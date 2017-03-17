//
//  HomeViewController.swift
//  weLearn
//
//  Created by Karen Fuentes on 2/27/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import SnapKit

fileprivate let announcementCellID = "AnnouncemntCell"
fileprivate let agendaCellID = "AgendaCellID"
fileprivate let dueDatesCellID = "DueDatesCellID"

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Dummy timer created up here!
    
    var timeInSeconds = 150
    var timer: Timer!
    
    let currentDate = Date()
    let calendar = Calendar.current
    var agenda: [Agenda]?
    var assignments: [Assignment]? {
        didSet {
            User.manager.assignments = assignments
        }
    }
    
    var todaysAgenda: Agenda?
    var nextDue: Assignment?
    var todaysFakeSchedule: [String] = [
        "Schedule for Today",
        "DSA",
        "Sprite Kit with Louis",
        "Capstone",
        "Lunch break",
        "Talk to Tech Mentors",
        "Workshop at Headquarters"
    ]
    
    // This will be variable based on the Student's Class, pending Firebase setup
    let agendaSheetID = "1o2OX0aweZIEiIgZNclasDH3CNYAX_doBNweP59cvfx4"
    let assignmentSheetID = "1X0u5jM7-L4RSqdGC0AWa1XsyvSusV2wLDTtmwgBERJA"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        registerCell()
        viewHiearchy()
        configureConstraints()
        // readAgenda()
        readAssignments()
        
        let dateInTitle = DateFormatter()
        dateInTitle.dateFormat = "E, MMM dd"
        
        navigationController?.navigationBar.isHidden = false
        title = dateInTitle.string(from: currentDate)
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 268.0
        
        // the below code hides the top part of the tableview under the navbar, giving the illusion that there is no first section bar
        // tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        
        profileButton.addTarget(self, action: #selector(profileButtonWasPressed(button:)), for: .touchUpInside)
        let leftButton = UIBarButtonItem(customView: profileButton)
        navigationItem.setLeftBarButton(leftButton, animated: true)
        
        linksButton.addTarget(self, action: #selector(linksButtonWasPressed(button:)), for: .touchUpInside)
        let rightButton = UIBarButtonItem(customView: linksButton)
        navigationItem.setRightBarButton(rightButton, animated: true)
    }
    
    // MARK: - Layout Setup
    func viewHiearchy() {
        self.view.addSubview(tableView)
    }
    
    func configureConstraints(){
        
        self.edgesForExtendedLayout = []
        tableView.snp.makeConstraints { (tV) in
            tV.leading.trailing.bottom.top.equalToSuperview()
        }
    }
    
    func registerCell() {
        tableView.register(AnnouncementTableViewCell.self, forCellReuseIdentifier: announcementCellID)
        tableView.register(AgendaTableViewCell.self, forCellReuseIdentifier: agendaCellID)
        tableView.register(DueDatesTableViewCell.self, forCellReuseIdentifier: dueDatesCellID)
    }
    
    // MARK: - Functions and Methods
    
    //    func readAgenda() {
    //        APIRequestManager.manager.getData(endPoint: "https://spreadsheets.google.com/feeds/list/\(agendaSheetID)/od6/public/basic?alt=json") { (data: Data?) in
    //            if data != nil {
    //                if let returnedAgenda = Agenda.getAgenda(from: data!) {
    //                    print("We've got returns: \(returnedAgenda.count)")
    //                    self.agenda = returnedAgenda
    //                    DispatchQueue.main.async {
    //                        self.todaysAgenda = self.todaysSchedule()
    //                        self.tableView.reloadData()
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    func readAssignments() {
        APIRequestManager.manager.getData(endPoint: "https://spreadsheets.google.com/feeds/list/\(assignmentSheetID)/od6/public/basic?alt=json") { (data: Data?) in
            if data != nil {
                if let returnedAssignments = Assignment.getAssignment(from: data!) {
                    print("We've got returns: \(returnedAssignments.count)")
                    self.assignments = returnedAssignments
                    DispatchQueue.main.async {
                        self.nextDue = self.findNextDue() {
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func findNextDue(_ completion: @escaping () -> Void) -> Assignment? {
        if let assignments = assignments {
            _ = assignments.sorted(by: {$0.date > $1.date})
            let today = Date()
            for entry in assignments {
                if today <= entry.date  {
                    return entry
                }
            }
        }
        return nil
    }
    
    func fakeReadAgenda(_ items: [Agenda]) {
        self.agenda = items
        DispatchQueue.main.async {
            self.todaysAgenda = self.todaysSchedule()
            self.tableView.reloadData()
        }
    }
    
    func todaysSchedule() -> Agenda? {
        if let agenda = agenda {
            LessonSchedule.manager.setAgenda(agenda)
            if let agendaception = LessonSchedule.manager.pastAgenda {
                return agendaception[0]
            }
        }
        return nil
    }
    
    // MARK: - TableView DataSource Methods
    
    // MARK: Section Code
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Announcements"
        case 0:
            //            //            if todaysAgenda != nil {
            return "Today's Schedule"
            //            }
            //            else {
            //                return nil
        //            }
        case 2:
            return "Assignments & Events"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            //Announcement
            return 1
        case 0:
            //Agenda
            return todaysFakeSchedule.count
            //            if todaysAgenda != nil {
            //                return 1
            //            } else {
            //                return 0
        //            }
        case 2:
            //DueDates
            return 1
        default:
            break
        }
        return 0
    }
    
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return 10
    //    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //        the commneted out stuff below makes the section header for the top very small, so we can easily hide it under the nav bar
        //        if section == 0 {
        //            return 1
        //        } else {
        return 30
        //        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.weLearnBlue
        header.textLabel?.font = UIFont(name: "Avenir-Light", size: 30)
        header.textLabel?.textAlignment = .center
        header.textLabel?.adjustsFontSizeToFitWidth = true
    }
    
    
    // MARK: Row Code
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch indexPath.section {
            
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: announcementCellID, for: indexPath)
            if let firstCell = cell as? AnnouncementTableViewCell {
                // the below code is so that the button (the box) does not override touch detection to the cell
                firstCell.contentView.isUserInteractionEnabled = false
                
                firstCell.date.text = self.title
                firstCell.quote.text = "You all got A's! Wow!"
                firstCell.author.text = "- Ben"
                firstCell.bar.isHidden = true
            }
            
            return cell
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: agendaCellID, for: indexPath)
            
            if let secondCell = cell as? AgendaTableViewCell {
                secondCell.selectionStyle = .none
                secondCell.label.text = todaysFakeSchedule[indexPath.row]
                secondCell.label.font = UIFont(name: "Avenir-Roman", size: 16)
                
                //            if let agenda = agenda {
                //                if let secondCell = cell as? AgendaTableViewCell {
                //                    let agendaForCell = agenda[indexPath.row]
                //                    secondCell.label.text = agendaForCell.lessonName
                //                    secondCell.label.font = UIFont(name: "Avenir-Roman", size: 16)
                //                }
                //            }
                //            if let today = todaysAgenda {
                //                if let secondCell = cell as? AgendaTableViewCell {
                //                    secondCell.label.text = "\(today.lessonName) - \(today.lessonDesc ?? "Just Keep On Keeping On!")"
                //                    secondCell.label.font = UIFont(name: "Avenir-Roman", size: 16)
                //                }
                // }
                
                // the commented out code below makes the bold "section header" seen in the demo
                //            if indexPath.row == 0 {
                //                secondCell.label.font = UIFont(name: "Avenir-Black", size: 16)
                //                secondCell.bulletView.isHidden = true
                //                }
            }
            
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: dueDatesCellID, for: indexPath)
            if let thirdCell = cell as? DueDatesTableViewCell {
                // the below code is so that the button (the box) does not override touch detection to the cell
                thirdCell.contentView.isUserInteractionEnabled = false
                
                thirdCell.timerLabel.text = "7 days"
                thirdCell.assignmentLabel.text = "until midterm..."
                // MARK: - Dummy timer runs down here!
                
                /* Remove the upcoming pair of stars and slashes on this line to comment out dummy timer */
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
                    //                    guard self.timeInSeconds > 0  else {
                    //                        self.timer.invalidate()
                    //                        return
                    //                    }
                    if let nextDueCountdown = self.nextDue {
                        
                        let startTime = Date()
                        let endTime = nextDueCountdown.date
                        let difference = endTime.timeIntervalSince(startTime)
                        
                        self.timeInSeconds = Int(difference)
                        
                        self.timeInSeconds -= 1
                        let days = Int(self.timeInSeconds) / 86400
                        let hours = Int(self.timeInSeconds) / 3600 % 24
                        let minutes = Int(self.timeInSeconds) / 60 % 60
                        
                        thirdCell.timerLabel.text = String(format: "%i days, %i hours, and %i minutes", days, hours, minutes)
                        thirdCell.assignmentLabel.text = " until \(nextDueCountdown.assignmentTitle)..."
                    }
                }
                
                timer.fire()
            }
            
        default:
            break
        }
        
        cell.layer.shadowOffset = CGSize(width: 2, height: 3)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowRadius = 3
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1: // break
            navigationController?.pushViewController(OldAnnouncementsTableViewController(), animated: true)
        case 0: //break
            navigationController?.pushViewController(AgendaTableViewController(), animated: true)
        case 2: //break
            let newvc = AssignmentTableViewController()
            let days = Int(self.timeInSeconds) / 86400
            let hours = Int(self.timeInSeconds) / 3600 % 24
            let minutes = Int(self.timeInSeconds) / 60 % 60
            
            newvc.stopTime = String(format: "%02i days, %02i hours, and %02i minutes", days, hours, minutes)
            
            navigationController?.pushViewController(newvc, animated: true)
        default:
            break
        }
    }
    
    // MARK: - Button Functions
    
    func profileButtonWasPressed(button: UIButton) {
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    func linksButtonWasPressed(button: UIButton) {
        navigationController?.pushViewController(LinkTableViewController(), animated: true)
    }
    
    // MARK: - UI Elements
    
    lazy var profileButton: ShinyOvalButton = {
        let button = ShinyOvalButton()
        button.setTitle("profile".uppercased(), for: .normal)
        //button.backgroundColor = UIColor.weLearnBlue.withAlphaComponent(0.25)
        //button.backgroundColor = UIColor.weLearnBlue
        button.layer.cornerRadius = 15
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        //button.setImage(#imageLiteral(resourceName: "profileIcon"), for: .normal)
        //button.imageView?.contentMode = .center
        button.imageView?.clipsToBounds = true
        //        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        //        button.layer.shadowOpacity = 0.25
        //        button.layer.shadowRadius = 2
        return button
    }()
    
    lazy var linksButton: ShinyOvalButton = {
        let button = ShinyOvalButton()
        button.setTitle("links".uppercased(), for: .normal)
        //button.backgroundColor = UIColor.weLearnBlue.withAlphaComponent(0.25)
        button.layer.cornerRadius = 15
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        //button.setImage(#imageLiteral(resourceName: "logoForNavBarButton"), for: .normal)
        //button.imageView?.contentMode = .center
        button.imageView?.clipsToBounds = true
        //        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        //        button.layer.shadowOpacity = 0.25
        //        button.layer.shadowRadius = 2
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()//(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
}
