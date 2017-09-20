//
//  AgendaTableViewController.swift
//  weLearn
//
//  Created by Karen Fuentes on 3/8/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import AudioToolbox
import SafariServices
import FirebaseAuth

class AgendaTableViewController: UITableViewController {
    
    let agendaSheetID = MyClass.manager.lessonScheduleID!
    let toDoListSheetID = MyClass.manager.toDoListID
    let assignmentSheetID = MyClass.manager.assignmentsID!
    var todaysAgenda: Agenda?
    var toDoList: [String]? = ["Do your best", "Study hard", "Get sleep"] {
        didSet {
            Student.manager.toDoList = toDoList
        }
    }
    var checkedOff = [Int]()
    
    var agenda: [Agenda]?
    
    let currentDate = Date()
    
    var time = 0.0
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        grabToDoList()
        
        let dateInTitle = DateFormatter()
        dateInTitle.dateFormat = "EEEE, MMMM dd"
        let dateTitleString = dateInTitle.string(from: currentDate)
        
        self.navigationItem.title = dateTitleString
        self.tabBarController?.title = "Agenda"
        
        tableView.register(AgendaTableViewCell.self, forCellReuseIdentifier: "AgendaTableViewCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 268.0
        
        tableView.separatorStyle = .none
        
        self.view.addSubview(activityIndicator)
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.snp.makeConstraints { view in
            view.center.equalToSuperview()
        }
        
        tableView.reloadData()
        
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if agenda == nil {
            readAgenda()
        }
        
        grabToDoList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.view.subviews.contains(fanfare) {
            fanfareLabel.removeFromSuperview()
            fanfare.removeFromSuperview()
        }
    }
    
    // MARK: - Agenda functions
    
    func grabToDoList() {
        if Student.manager.toDoList == nil {
            APIRequestManager.manager.getData(endPoint: "https://spreadsheets.google.com/feeds/list/\(toDoListSheetID)/od6/public/basic?alt=json") { (data: Data?) in
                if data != nil {
                    if let returnedList = ToDoList.getTodaysList(from: data!) {
                        self.toDoList = returnedList
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        self.tableView.reloadData()
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
    
    func readAgenda() {
        self.view.bringSubview(toFront: activityIndicator)
        activityIndicator.startAnimating()
        
        if LessonSchedule.manager.pastAgenda == nil {
            APIRequestManager.manager.getData(endPoint: "https://spreadsheets.google.com/feeds/list/\(agendaSheetID)/od6/public/basic?alt=json") { (data: Data?) in
                if data != nil {
                    if let returnedAgenda = Agenda.getAgenda(from: data!) {
                        print("We've got returns: \(returnedAgenda.count)")
                        self.agenda = returnedAgenda
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            self.todaysAgenda = self.todaysSchedule()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        else {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.weLearnCoolWhite
        header.textLabel?.font = UIFont(name: "Avenir-Light", size: 30)
        header.textLabel?.textAlignment = .center
        header.textLabel?.adjustsFontSizeToFitWidth = true
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if agenda != nil {
                return todaysAgenda?.lessonName
            }
        case 1:
            if agenda != nil {
                return "Past Agendas"
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
            return toDoList?.count ?? 0
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
        
        switch indexPath.section {
        case 0:
            cell.selectionStyle = .blue
            
            if let toDo = toDoList {
                cell.label.text = toDo[indexPath.row]
            }
            
            if checkedOff.contains(indexPath.row) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
        case 1:
            cell.selectionStyle = .none
            
            if let agenda = LessonSchedule.manager.pastAgenda {
                let agendaAtRow = agenda[indexPath.row]
                cell.label.text = "\(agendaAtRow.dateString) - \(agendaAtRow.lessonName)"
                cell.bulletView.isHidden = true
            }
        default:
            break
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else {
            AudioServicesPlaySystemSound(1103)
            return
        }
        
        AudioServicesPlaySystemSound(1104)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            if cell.accessoryType == .none {
                checkedOff.append(indexPath.row)
                cell.accessoryType = .checkmark
            } else {
                if let indexOfCellToRemove = checkedOff.index(of: indexPath.row) {
                    checkedOff.remove(at: indexOfCellToRemove)
                    cell.accessoryType = .none
                }
            }
            
            if checkedOff.count == toDoList?.count {
                
                if !self.view.subviews.contains(fanfare) {
                    self.view.addSubview(fanfareLabel)
                    self.view.addSubview(fanfare)
                } else {
                    fanfare.alpha = 1
                    fanfareLabel.alpha = 1
                }
                
                
                fanfareLabel.snp.makeConstraints { view in
                    view.top.equalToSuperview().offset(200)
                    view.centerX.equalToSuperview()
                    view.width.equalToSuperview()
                }
                
                fanfare.snp.makeConstraints { view in
                    view.top.bottom.equalToSuperview()
                    view.leading.trailing.equalToSuperview()
                }
                
                fanfareLabel.text = "Hooray! You made it through the day!"
                
                self.time = 0
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.checkTime), userInfo: nil, repeats: true)
                self.timer.fire()
            }
        }
    }
    
    func checkTime () {
        if self.time >= 2.6  {
            fanfareLabel.alpha = 0
            
            UIView.animate(withDuration: 1, animations: {
                self.fanfare.alpha = 0
            })
            
            timer.invalidate()
        }
        
        self.time += 0.1
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        return view
    }()
    
    lazy var fanfare: UIView = {
        let view = UIView()
        
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 700)
        
        // from https://www.invasivecode.com/weblog/caemitterlayer-and-the-ios-particle-system-lets/?doing_wp_cron=1489935545.9552049636840820312500 and https://www.hackingwithswift.com/example-code/calayer/how-to-emit-particles-using-caemitterlayer
        
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = CGPoint(x: view.frame.midX, y: view.frame.minY)
        emitterLayer.emitterZPosition = 10
        emitterLayer.emitterSize = CGSize(width: view.frame.size.width, height: 1)
        emitterLayer.emitterShape = kCAEmitterLayerLine
        
        func makeCell(color: UIColor) -> CAEmitterCell {
            let cell = CAEmitterCell()
            cell.birthRate = 10
            cell.lifetime = 7.0
            cell.lifetimeRange = 0
            cell.velocity = 100
            cell.velocityRange = 50
            cell.yAcceleration = 250
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = CGFloat.pi / 4
            cell.spin = 2
            cell.spinRange = 3
            cell.scale = 0.1
            cell.scaleRange = 0.75
            cell.scaleSpeed = -0.05
            cell.contents = #imageLiteral(resourceName: "bullet").cgImage
            cell.color = color.cgColor
            
            return cell
        }
        
        let green = makeCell(color: UIColor(red:0.30, green:0.85, blue:0.39, alpha:1.0))
        let pureWhite = makeCell(color: UIColor.white)
        let lightBlue = makeCell(color: UIColor.weLearnLightBlue)
        let coolWhite = makeCell(color: UIColor.weLearnCoolWhite)
        let yellow =  makeCell(color: UIColor(red:1.00, green:0.80, blue:0.00, alpha:1.0))
        let red = makeCell(color: UIColor(red:1.00, green:0.18, blue:0.33, alpha:1.0))
        
        emitterLayer.emitterCells = [green, coolWhite, lightBlue, pureWhite, yellow, red]
        view.layer.addSublayer(emitterLayer)
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        return view
    }()
    
    lazy var fanfareLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "Avenir-HeavyOblique", size: 36)
        label.textAlignment = .center
        label.numberOfLines = 5
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = UIColor.weLearnBrightBlue.withAlphaComponent(0.8)
        return label
    }()
}
