//
//  ProfileViewController.swift
//  weLearn
//
//  Created by Marty Avedon on 3/7/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // we shall make cells for the acheievements and grades
    // grades will be a simple cell
    // achievements will be a cell containing...a collection view or scroll view
    
    //    var grades = [Grade]()
    var testGrades: TestGrade?
    var gradesParsed: [(assignment: String, grade: String)] = []
    // subject to change
    var gradesSheetID = "1nWAy8nkwuPiOJkMvsdKOrwOPWgptVhNAbRrdBZlNPvA"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "Profile"
        
        self.view.backgroundColor = UIColor.weLearnLightGreen
        
        viewHeirarchy()
        configureConstraints()
        
        self.edgesForExtendedLayout = .bottom
        
        tableView.register(AchievementTableViewCell.self, forCellReuseIdentifier: "AchievementTableViewCell")
        tableView.register(GradeTableViewCell.self, forCellReuseIdentifier: "GradeTableViewCell")
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 268.0
        
        checkLoggedIn()
        // Do any additional setup after loading the view.
    }
    
    func checkLoggedIn() {
        if FIRAuth.auth()?.currentUser != nil {
            grabTestData()
        }
    }
    
    func grabTestData() {
        APIRequestManager.manager.getData(endPoint: "https://spreadsheets.google.com/feeds/list/\(gradesSheetID)/od6/public/basic?alt=json") { (data: Data?) in
            if data != nil {
                let studentID = FIRAuth.auth()?.currentUser?.uid
                if let returnedGradesData = TestGrade.getStudentTestGrade(from: data!,
                                                                          for: "3236" /*studentID*/) {
                    print("We've got grades for: \(returnedGradesData.id)")
                    
                    self.testGrades = returnedGradesData
                    self.gradesParsed = TestGrade.parseGradeString(self.testGrades!.grades)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func viewHeirarchy() {
        self.view.addSubview(profileBox)
        self.view.addSubview(profilePic)
        self.view.addSubview(nameLabel)
        self.view.addSubview(emailLabel)
        self.view.addSubview(classLabel)
        self.view.addSubview(editButton)
        self.view.addSubview(tableView)
        //        self.view.addSubview(achievementBox)
        //        self.view.addSubview(titleForAchievementsBox)
        //        self.view.addSubview(gradesBox)
        //        self.view.addSubview(titleForGradesBox)
    }
    
    func configureConstraints() {
        tableView.snp.makeConstraints { (tV) in
            tV.leading.trailing.bottom.equalToSuperview()
            tV.top.equalTo(profileBox.snp.bottom)
        }
        
        profileBox.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(20)
            view.centerX.equalToSuperview()
            view.leading.equalToSuperview().offset(25)
            view.trailing.equalToSuperview().inset(25)
        }
        
        profilePic.snp.makeConstraints { view in
            view.top.leading.equalTo(profileBox).offset(20)
            view.width.equalTo(profileBox).dividedBy(4)
            view.height.equalTo(profilePic.snp.width)
        }
        
        nameLabel.snp.makeConstraints { view in
            view.top.equalTo(profileBox).offset(20)
            view.trailing.equalTo(profileBox).inset(20)
        }
        
        emailLabel.snp.makeConstraints { view in
            view.top.equalTo(nameLabel.snp.bottom).offset(10)
            view.trailing.equalTo(profileBox).inset(20)
        }
        
        classLabel.snp.makeConstraints { view in
            view.top.equalTo(emailLabel.snp.bottom).offset(5)
            view.trailing.equalTo(profileBox).inset(20)
            view.bottom.equalTo(profileBox).inset(20)
        }
        
        //        achievementBox.snp.makeConstraints { view in
        //            view.top.equalTo(profileBox.snp.bottom).offset(20)
        //            view.centerX.equalToSuperview()
        //            view.leading.equalToSuperview().offset(25)
        //            view.trailing.equalToSuperview().inset(25)
        //            view.height.equalTo(100)
        //        }
        //
        //        titleForAchievementsBox.snp.makeConstraints { view in
        //            view.top.leading.equalTo(achievementBox).offset(20)
        //        }
        //
        //        gradesBox.snp.makeConstraints {view in
        //            view.top.equalTo(achievementBox.snp.bottom).offset(20)
        //            view.centerX.equalToSuperview()
        //            view.leading.equalToSuperview().offset(25)
        //            view.trailing.equalToSuperview().inset(25)
        //            view.height.equalTo(150)
        //        }
        //
        //        titleForGradesBox.snp.makeConstraints { view in
        //            view.top.leading.equalTo(gradesBox).offset(20)
        //        }
    }
    
    // Mark: - Table view stuff
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Achievements"
        case 1:
            return "Grades"
        default:
            return ""
        }
    }
    
    //    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    //        let header = view as! UITableViewHeaderFooterView
    //        header.textLabel?.font = UIFont(name: "Avenir-Black", size: 16)
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            // Achievements
            return 1
        case 1:
            // Grades
            // return grades.count
            if testGrades != nil {
                return self.gradesParsed.count
            }
            else {
                return 1
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "AchievementTableViewCell", for: indexPath)
            if let achieviementCell = cell as? AchievementTableViewCell {
                achieviementCell
            }
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "GradeTableViewCell", for: indexPath)
            if gradesParsed.count > 0 {
                if let gradeCell = cell as? GradeTableViewCell {
                    gradeCell.testNameLabel.text = gradesParsed[indexPath.row].assignment
                    gradeCell.gradeLabel.text = gradesParsed[indexPath.row].grade
                }
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
    
    // Mark: - Views made here
    
    lazy var profileBox: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: -2, height: 3)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 3
        view.layer.masksToBounds = false
        return view
    }()
    
    lazy var profilePic: UIImageView = {
        let pic = UIImageView()
        pic.layer.borderColor = UIColor.black.cgColor
        pic.image = #imageLiteral(resourceName: "profileIcon")
        pic.layer.borderWidth = 5
        return pic
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.weLearnCoolWhite
        label.text = "Karen Fuentes"
        label.font = UIFont(name: "Avenir-Light", size: 24)
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.weLearnCoolWhite
        label.text = "karen@karen.com"
        label.font = UIFont(name: "Avenir-LightOblique", size: 16)
        return label
    }()
    
    lazy var classLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.weLearnCoolWhite
        label.text = "AC3.2"
        label.font = UIFont(name: "Avenir-LightOblique", size: 16)
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    //    lazy var achievementBox: UIView = {
    //        let view = UIView()
    //        view.backgroundColor = UIColor.white
    //        view.layer.shadowColor = UIColor.black.cgColor
    //        view.layer.shadowOffset = CGSize(width: -2, height: 3)
    //        view.layer.shadowOpacity = 0.5
    //        view.layer.shadowRadius = 3
    //        view.layer.masksToBounds = false
    //        return view
    //    }()
    //
    //    lazy var titleForAchievementsBox: UIView = {
    //        let label = UILabel()
    //        label.font = UIFont(name: "Avenir-Black", size: 20)
    //        label.text = "Achievements"
    //        return label
    //    }()
    //
    //    lazy var gradesBox: UIView = {
    //        let view = UIView()
    //        view.backgroundColor = UIColor.white
    //        view.layer.shadowColor = UIColor.black.cgColor
    //        view.layer.shadowOffset = CGSize(width: -2, height: 3)
    //        view.layer.shadowOpacity = 0.5
    //        view.layer.shadowRadius = 3
    //        view.layer.masksToBounds = false
    //        return view
    //    }()
    //
    //    lazy var titleForGradesBox: UIView = {
    //        let label = UILabel()
    //        label.font = UIFont(name: "Avenir-Black", size: 20)
    //        label.text = "Grades"
    //        return label
    //    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView() //(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
}
