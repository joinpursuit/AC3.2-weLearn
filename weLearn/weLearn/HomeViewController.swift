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
    
    /* dummy timer -- remove star and slash on this line to comment out */
    var timeInSeconds = 1555200
    var timer: Timer!
    //*/
    
    let currentDate = Date()
    let calendar = Calendar.current
    var agenda: [Agenda]?
    var todaysAgenda: Agenda?
    
    // This will be variable based on the Student's Class, pending Firebase setup
    let agendaSheetID = "1o2OX0aweZIEiIgZNclasDH3CNYAX_doBNweP59cvfx4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        registerCell()
        viewHiearchy()
        configureConstraints()
        readAgenda()
        
        let dateInTitle = DateFormatter()
        dateInTitle.dateFormat = "E, MMM dd"
        
        title = dateInTitle.string(from: currentDate)
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 268.0
        
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
    
    func readAgenda() {
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
    
    func fakeReadAgenda(_ items: [Agenda]) {
        self.agenda = items
        DispatchQueue.main.async {
            self.todaysAgenda = self.todaysSchedule()
            self.tableView.reloadData()
        }
    }
    
    func todaysSchedule() -> Agenda? {
        if let agenda = agenda {
            _ = agenda.sorted(by: {$0.date < $1.date})
            let today = Date()
            for entry in agenda {
                if today <= entry.date  {
                    return entry
                }
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
            //        case 0:
        //            return "Announcements"
        case 1:
            if todaysAgenda != nil {
                return "Agenda"
            }
            else {
                return nil
            }
            //        case 2:
        //            return "Upcoming Due Dates"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            //Announcement
            return 1
        case 1:
            //Agenda
            if todaysAgenda != nil {
                return 1
            } else {
                return 0
            }
        case 2:
            //DueDates
            return 1
        default:
            break
        }
        return 0
    }
    
    // MARK: Row Code
    
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return 20
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch indexPath.section {
            
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: announcementCellID, for: indexPath)
            if let firstCell = cell as? AnnouncementTableViewCell {
                firstCell.date.text = self.title
                firstCell.quote.text = "You all got A's! Wow!"
                firstCell.author.text = "- Ben"
                firstCell.bar.isHidden = true
            }
            
            return cell
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: agendaCellID, for: indexPath)
            //            if let agenda = agenda {
            //                if let secondCell = cell as? AgendaTableViewCell {
            //                    let agendaForCell = agenda[indexPath.row]
            //                    secondCell.label.text = agendaForCell.lessonName
            //                    secondCell.label.font = UIFont(name: "Avenir-Roman", size: 16)
            //                }
            //            }
            if let today = todaysAgenda {
                if let secondCell = cell as? AgendaTableViewCell {
                    secondCell.label.text = "\(today.lessonName) - \(today.repoURL)"
                    secondCell.label.font = UIFont(name: "Avenir-Roman", size: 16)
                }
            }
            
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: dueDatesCellID, for: indexPath)
            if let thirdCell = cell as? DueDatesTableViewCell {
                thirdCell.timerLabel.text = "7 days"
                thirdCell.assignmentLabel.text = "until midterm..."
                // MARK: - Dummy timer runs down here!
                
                /* Remove the upcoming pair of stars and slashes on this line to comment out dummy timer */
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
                    guard self.timeInSeconds > 0  else {
                        self.timer.invalidate()
                        return
                    }
                    
                    self.timeInSeconds -= 1
                    let days = Int(self.timeInSeconds) / 86400
                    let hours = Int(self.timeInSeconds) / 3600 % 24
                    let minutes = Int(self.timeInSeconds) / 60 % 60

                    thirdCell.timerLabel.text = String(format: "%02i days, %02i hours, and %02i minutes", days, hours, minutes)
                    thirdCell.assignmentLabel.text = " until Demo Day..."
                }
                
                timer.fire()
                //*/
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
        case 0:
            navigationController?.pushViewController(OldAnnouncementsTableViewController(), animated: true)
        case 1: break
        case 2: //break
            navigationController?.pushViewController(AssignmentTableViewController(), animated: true)
        default:
            break
        }
    }
    
    
    // MARK: - Button Functions
    
    func profileButtonWasPressed(button: UIButton) {
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    func linksButtonWasPressed(button: UIButton) {
        //    navigationController?.pushViewController(LinksCollectionViewController(), animated: true)
    }
    
    // MARK: - UI Elements
    
    lazy var profileButton: ShinyOvalButton = {
        let button = ShinyOvalButton()
        // button.setTitle("profile".uppercased(), for: .normal)
        //button.backgroundColor = UIColor.weLearnGreen
        button.layer.cornerRadius = 15
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(#imageLiteral(resourceName: "profileIcon"), for: .normal)
        button.imageView?.contentMode = .center
        button.imageView?.clipsToBounds = true
        return button
    }()
    
    lazy var linksButton: ShinyOvalButton = {
        let button = ShinyOvalButton()
        button.setTitle("links".uppercased(), for: .normal)
        //button.backgroundColor = UIColor.weLearnGreen
        button.layer.cornerRadius = 15
        button.frame = CGRect(x: 0, y: 0, width: 65, height: 30)
        //button.setImage(#imageLiteral(resourceName: "logoForNavBarButton"), for: .normal)
        //button.imageView?.contentMode = .center
        button.imageView?.clipsToBounds = true
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()//(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
}
