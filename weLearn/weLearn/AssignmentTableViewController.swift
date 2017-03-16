//
//  AssignmentTableViewController.swift
//  weLearn
//
//  Created by Karen Fuentes on 2/27/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import SafariServices
import FirebaseAuth

class AssignmentTableViewController: UITableViewController, Tappable {
    
    var assignments: [Assignment]? {
        didSet {
            User.setAssignmentsReversed(assignments)
        }
    }
    
    let assignmentSheetID = MyClass.manager.assignmentsID!
    
    var stopTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Assignments"
        self.tabBarController?.title = navigationItem.title
        
        tableView.register(AssignmentTableViewCell.self, forCellReuseIdentifier: "AssignmentTableViewCell")
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 268.0
        
        readAssignments()
    }
    
    func readAssignments() {
        if User.manager.assignments == nil {
            APIRequestManager.manager.getData(endPoint: "https://spreadsheets.google.com/feeds/list/\(assignmentSheetID)/od6/public/basic?alt=json") { (data: Data?) in
                if data != nil {
                    if let returnedAssignments = Assignment.getAssignment(from: data!) {
                        print("We've got returns: \(returnedAssignments.count)")
                        self.assignments = returnedAssignments
                        DispatchQueue.main.async {
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
        if let assignments = User.manager.assignments {
            if let link = assignments[index.row].url {
                let svc = SFSafariViewController(url: URL(string: link)!)
                present(svc, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let assignments = assignments {
            return assignments.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentTableViewCell", for: indexPath)
        // cell.selectionStyle = .none
        
        if let assignmentCell = cell as? AssignmentTableViewCell {
            if assignmentCell.delegate == nil {
                assignmentCell.delegate = self
            }
            if let assignments = User.manager.assignments {
                /*
                 guard (assignments[indexPath.row].score?.characters.count)! < 3 else {
                 assignmentCell.assignmentNameLabel.text = "\(assignments[indexPath.row].assignmentTitle) due in"
                 assignmentCell.gradeLabel.font = UIFont(name: "Avenir-Black", size: 20)
                 assignmentCell.gradeLabel.layer.shadowColor = UIColor.clear.cgColor
                 assignmentCell.gradeLabel.text = assignments[indexPath.row].score
                 assignmentCell.topHorizontalRule.isHidden = true
                 assignmentCell.bottomHorizontalRule.isHidden = true
                 //assignmentCell.repoLink.isHidden = true
                 return cell
                 }
                 */
                let assignment = assignments[indexPath.row]
                let endTime = assignment.date
                let difference = endTime.timeIntervalSinceNow
                
                if difference < 0 {
                    assignmentCell.assignmentNameLabel.text = convertDateToString(assignment.date)
                    assignmentCell.gradeLabel.text = assignment.assignmentTitle
                    
                }
                else {
                    let endTime = assignment.date
                    let difference = endTime.timeIntervalSinceNow
                    var timeInSeconds = 0
                    timeInSeconds = Int(difference)
                    
                    let days = Int(timeInSeconds) / 86400
                    let hours = Int(timeInSeconds) / 3600 % 24
                    let minutes = Int(timeInSeconds) / 60 % 60
                    
                    assignmentCell.assignmentNameLabel.text = String(format: "%i days, %i hours, %i minutes until", days, hours, minutes)
                    assignmentCell.gradeLabel.text = assignment.assignmentTitle
                    
                    //                assignmentCell.assignmentNameLabel.text = assignments[indexPath.row].assignmentTitle
                    //                  assignmentCell.dateLabel.text = assignments[indexPath.row].date
                    //                    guard assignments[indexPath.row].url != nil else {
                    //                        //                    assignmentCell.repoLink.isHidden = true
                    //                    }
                    //assignmentCell.repoLink.setTitle("Link to Repo", for: .normal)
                }
                return cell
            }
        }
        
        return cell
    }
    
    func convertDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        
        return dateFormatter.string(from: date)
    }
    
    // Button
    
    lazy var logOutButton: ShinyOvalButton = {
        let button = ShinyOvalButton()
        button.setTitle("Log Out".uppercased(), for: .normal)
        button.setTitleColor(UIColor.weLearnBlue, for: .normal)
        button.layer.cornerRadius = 15
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        button.imageView?.clipsToBounds = true
        return button
    }()
    
    // MARK: - Button Action
    
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
}
