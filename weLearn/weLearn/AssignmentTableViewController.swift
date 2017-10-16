//
//  AssignmentTableViewController.swift
//  weLearn
//
//  Created by Karen Fuentes on 2/27/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import AudioToolbox
import SafariServices
import FirebaseAuth
import Firebase

class AssignmentTableViewController: UITableViewController, SFSafariViewControllerDelegate, Tappable {
    
    var assignments: [Assignment]? {
        didSet {
            Student.setAssignmentsReversed(assignments)
        }
    }
    
    var gradesParsed: [(assignment: String, grade: String)] = [] {
        didSet {
            Student.manager.assignmentGrades = gradesParsed.reversed()
        }
    }
    
    var timeInSeconds = 1
    var timer: Timer!
    
    let assignmentSheetID = MyClass.manager.assignmentsID!
    let gradeBookSheetID = MyClass.manager.gradeBookID!
    var assignmentGrades: AssignmentGrade?
    var databaseReference: DatabaseReference!
    
    var stopTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Assignments"
        self.tabBarController?.title = navigationItem.title
        
        databaseReference = Database.database().reference()
        
        tableView.register(AssignmentTableViewCell.self, forCellReuseIdentifier: "AssignmentTableViewCell")
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 268.0
        
        self.view.addSubview(activityIndicator)
        self.view.addSubview(emptyGrades)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.activityIndicator.snp.makeConstraints { view in
            view.center.equalToSuperview()
        }
        
        self.emptyGrades.snp.makeConstraints { view in
            view.center.equalTo(tableView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        if assignments == nil {
            startGrabbingAssignmentsData()
            readAssignments()
        }
    }
    
    func startGrabbingAssignmentsData() {
        self.view.bringSubview(toFront: activityIndicator)
        self.activityIndicator.startAnimating()
        
        if Student.manager.assignmentGrades == nil {
            APIRequestManager.manager.getData(endPoint: "https://spreadsheets.google.com/feeds/list/\(gradeBookSheetID)/od6/public/basic?alt=json") { (data: Data?) in
                if data != nil {
                    self.fetchStudentAssignmentData(data!)
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
         self.activityIndicator.stopAnimating()
    }
    
    func fetchStudentAssignmentData(_ data: Data) {
        if let studentID = Student.manager.id {
            if let returnedGradesData = AssignmentGrade.getStudentAssignmentGrade(from: data, for: studentID) {
                print("\n\n\nWe've got grades for: \(returnedGradesData.id)")
                
                self.assignmentGrades = returnedGradesData
                self.gradesParsed = AssignmentGrade.parseGradeString(self.assignmentGrades!.grades)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            } else {
                print("error loading data!")
                emptyGrades.isHidden = false
                self.activityIndicator.stopAnimating()
                self.view.setNeedsLayout()

            }
        }
    }
    
    func readAssignments() {
        if Student.manager.assignments == nil {
            APIRequestManager.manager.getData(endPoint: "https://spreadsheets.google.com/feeds/list/\(assignmentSheetID)/od6/public/basic?alt=json") { (data: Data?) in
                if data != nil {
                    if let returnedAssignments = Assignment.getAssignment(from: data!) {
                        print("We've got returns: \(returnedAssignments.count)")
                        self.assignments = returnedAssignments
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func cellTapped(cell: UITableViewCell) {
        self.repoButtonClicked(at: tableView.indexPath(for: cell)!)
    }
    
    func repoButtonClicked(at index: IndexPath) {
        let currentCell = tableView.cellForRow(at: index) as! AssignmentTableViewCell
        
        UIView.animate(withDuration: 0.5, animations: {
            currentCell.box.layer.shadowOpacity = 0.1
            currentCell.box.layer.shadowRadius = 1
            currentCell.box.apply(gradient: [UIColor.weLearnGrey.withAlphaComponent(0.1), UIColor.weLearnGrey.withAlphaComponent(0.1), UIColor.weLearnCoolWhite])
        }, completion: { finish in
            currentCell.box.layer.shadowOpacity = 0.25
            currentCell.box.layer.shadowRadius = 2
            currentCell.box.layer.sublayers!.remove(at: 0)
        })
        
        if let assignments = Student.manager.assignments {
            if let link = assignments[index.row].url {
                AudioServicesPlaySystemSound(1105)
                let svc = SFSafariViewController(url: URL(string: link)!)
                navigationController?.show(svc, sender: self)
                svc.delegate = self
            } else {
                AudioServicesPlaySystemSound(1103)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if assignments !=  nil {
            return gradesParsed.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentTableViewCell", for: indexPath)
        cell.selectionStyle = .none
        
        if let assignmentCell = cell as? AssignmentTableViewCell {
            if assignmentCell.delegate == nil {
                assignmentCell.delegate = self
            }
            if let assignments = Student.manager.assignments {
                let assignment = assignments[indexPath.row]
                let endTime = assignment.date
                let difference = endTime.timeIntervalSinceNow
                
                if difference < 0 {
                    assignmentCell.assignmentNameLabel.text = assignment.assignmentTitle
                    assignmentCell.optionalTimerLabel.isHidden = true
                    assignmentCell.optionalTimerLabelsShadow.isHidden = true
                    if let gradeAtRow = Student.manager.assignmentGrades {
                        assignmentCell.assignmentCountDownLabel.text = "Grade: \(gradeAtRow[indexPath.row].grade)"
                    }
                } else {
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
                        guard self.timeInSeconds > 0  else {
                            self.timer.invalidate()
                            return
                        }
                        
                        let endTime = assignment.date
                        let difference = endTime.timeIntervalSinceNow as CFTimeInterval
                        self.timeInSeconds = Int(difference)
                        
                        self.timeInSeconds -= 1
                        
                        let days = Int(self.timeInSeconds) / 86400
                        let hours = Int(self.timeInSeconds) / 3600 % 24
                        let minutes = Int(self.timeInSeconds) / 60 % 60
                        let seconds = Int(self.timeInSeconds) % 60
                        
                        if assignmentCell.assignmentCountDownLabel.text == ""  || assignmentCell.assignmentCountDownLabel.text?.characters.last == "e" {
                            assignmentCell.assignmentCountDownLabel.text = String(format: "%i days, %i hours, %i minutes & %i seconds until ", days, hours, minutes, seconds) + "deadline"
                            assignmentCell.optionalTimerLabel.isHidden = false
                            assignmentCell.optionalTimerLabelsShadow.isHidden = false
                        }
                    }
                    
                    timer.fire()
                    
                    let properPercentage = (CGFloat(2016 - Int(self.timeInSeconds)/3600)/168)
                    assignmentCell.optionalTimerLabel.animate(towardsDeadline: properPercentage, forDuration: 1)
                    assignmentCell.assignmentNameLabel.text = assignment.assignmentTitle
                }
                
                return cell
            }
        }
        
        return cell
    }
    
    func convertDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, dd yyyy"
        
        return dateFormatter.string(from: date)
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        return view
    }()
    
    lazy var emptyGrades: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.backgroundColor = UIColor.weLearnBlue
        label.textColor = UIColor.weLearnCoolWhite
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir-LightOblique", size: 30)
        label.text = "No assignment grades yet"
        return label
    }()
}
