//
//  InitialViewController.swift
//  weLearn
//
//  Created by Karen Fuentes on 2/27/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth
import AudioToolbox
import FirebaseDatabase

class InitialViewController: UIViewController, UITextFieldDelegate {
    
    var databaseReference: FIRDatabaseReference!
    var databaseObserver: FIRDatabaseHandle?
    var signedInUser: FIRUser?
    
    var toggleIsHiddenWhenTabIsChanged = [UIView]()
    
    // Timer stuff for buttons
    
    var time = 0.0
    var timer: Timer!
    var selection: String?
    
    // MARK: Tab bar properties
    
    var TabViewController = UITabBarController()
    
    var tabAgenda = UITableViewController()
    var tabLinks = UITableViewController()
    var tabAnnouncements = UITableViewController()
    var tabProfile = UIViewController()
    var tabAssignments = UIViewController()
    
    var navControllerAgenda = UINavigationController()
    var navControllerLinks = UINavigationController()
    var navControllerAnnouncements = UINavigationController()
    var navControllerProfile = UINavigationController()
    var navControllerAssignments = UINavigationController()
    
    var viewControllers = [UINavigationController]()
    //    var viewControllers = [UIViewController]()
    
    var tabAgendaImage = #imageLiteral(resourceName: "agendaIcon")
    var tabLinksImage = #imageLiteral(resourceName: "linkIcon")
    var tabAnnouncementsImage = #imageLiteral(resourceName: "announcementIcon")
    var tabProfileImage = #imageLiteral(resourceName: "profileIcon")
    var tabAssignmentImage = #imageLiteral(resourceName: "assignmentIcon")
    
    // MARK: Views Did Do Things
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseReference = FIRDatabase.database().reference()
        
        self.time = 0.0
        
        self.view.apply(gradient: [UIColor.weLearnBlue, UIColor.white.withAlphaComponent(0.25)])
        
        self.passwordTextField.delegate = self
        
        viewHiearchy()
        configureConstraints()
        
        registerTab.backgroundColor = UIColor.weLearnLightGreen
        
        toggleIsHiddenWhenTabIsChanged = [
            registerButton,
            nameTextField,
            classTextField,
            studentIDTextField
        ]
        
//        self.checkLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loginTabWasPressed()
        activityIndicator.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        activityIndicator.stopAnimating()
        logoPic.transform = .identity
        logoOverlay.transform = .identity
        logoOverlay.alpha = 1
        // self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        hoverCloud()
    }
    
    //MARK: - Tab loading functions
    
    func loadTabsAndEverythingElse() {
        // Tabbar guts
        
        tabAgenda = AgendaTableViewController()
        tabLinks = LinkTableViewController()
        tabAnnouncements = OldAnnouncementsTableViewController()
        tabAssignments = AssignmentTableViewController()
        tabProfile = ProfileViewController()
        
        navControllerAgenda = UINavigationController(rootViewController: tabAgenda)
        navControllerLinks = UINavigationController(rootViewController: tabLinks)
        navControllerAnnouncements = UINavigationController(rootViewController: tabAnnouncements)
        navControllerAssignments = UINavigationController(rootViewController: tabAssignments)
        navControllerProfile = UINavigationController(rootViewController: tabProfile)
        
        viewControllers = [navControllerAgenda, navControllerLinks, navControllerAnnouncements, navControllerAssignments, navControllerProfile]
        
        //  viewControllers = [tabAgenda, tabLinks, tabAnnouncements, tabAssignments, tabProfile]
        TabViewController.viewControllers = viewControllers
        
        tabAgenda.tabBarItem = UITabBarItem(title: "Agenda", image: tabAgendaImage, tag: 1)
        tabLinks.tabBarItem = UITabBarItem(title: "Links", image: tabLinksImage, tag: 2)
        tabAnnouncements.tabBarItem = UITabBarItem(title: "Announcements", image: tabAnnouncementsImage, tag: 3)
        tabAssignments.tabBarItem = UITabBarItem(title: "Assignments", image: tabAssignmentImage, tag: 5)
        tabProfile.tabBarItem = UITabBarItem(title: "Profile", image: tabProfileImage, tag: 4)
        
        tabAgenda.view.backgroundColor = UIColor.weLearnBlue
        tabLinks.view.backgroundColor = UIColor.weLearnBlue
        tabAnnouncements.view.backgroundColor = UIColor.weLearnBlue
        tabAssignments.view.backgroundColor = UIColor.weLearnBlue
        tabProfile.view.backgroundColor = UIColor.weLearnBlue
        
        TabViewController.tabBar.tintColor = UIColor.weLearnBlue
        TabViewController.tabBar.barTintColor = UIColor.weLearnCoolWhite
        TabViewController.tabBar.unselectedItemTintColor = UIColor.weLearnGrey
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            self.view.endEditing(true)
            self.loginButtonWasPressed()
        }
        
        return true
    }
    
    func colorTab(button1: UIButton, button2: UIButton) {
        if button1.isSelected {
            button1.backgroundColor = UIColor.white
            button2.backgroundColor = UIColor.weLearnLightGreen
        } else {
            button1.backgroundColor = UIColor.weLearnLightGreen
            button2.backgroundColor = UIColor.white
        }
    }
    
    //MARK: - Autolayout Constraints and Hierarchy
    
    func viewHiearchy() {
        self.view.addSubview(logoPic)
        self.view.addSubview(logoOverlay)
        self.view.addSubview(registerTab)
        self.view.addSubview(registerTabLabel)
        self.view.addSubview(loginTab)
        self.view.addSubview(loginTabLabel)
        self.view.addSubview(box)
        self.view.addSubview(nameTextField)
        self.view.addSubview(classTextField)
        self.view.addSubview(studentIDTextField)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
        self.view.addSubview(activityIndicator)
    }
    
    func configureConstraints() {
        logoPic.snp.makeConstraints { view in
            view.width.equalToSuperview().dividedBy(2)
            view.height.equalToSuperview().dividedBy(5)
            view.top.equalToSuperview().offset(30)
            view.centerX.equalToSuperview()
        }
        
        logoOverlay.snp.makeConstraints { view in
            view.width.equalToSuperview().dividedBy(2)
            view.height.equalToSuperview().dividedBy(5)
            view.top.equalToSuperview().offset(30)
            view.centerX.equalToSuperview().offset(5)
        }
        
        box.snp.makeConstraints { view in
            view.top.equalTo(logoPic.snp.bottom).offset(60)
            view.centerX.equalToSuperview()
            view.leading.equalToSuperview().offset(25)
            view.trailing.equalToSuperview().inset(25)
        }
        
        loginTab.snp.makeConstraints { view in
            view.bottom.equalTo(box.snp.top)
            view.leading.equalTo(box)
            view.width.equalTo(box).dividedBy(2)
            view.height.equalTo(40)
        }
        
        loginTabLabel.snp.makeConstraints { view in
            view.center.equalTo(loginTab)
        }
        
        registerTab.snp.makeConstraints { view in
            view.bottom.equalTo(box.snp.top)
            view.trailing.equalTo(box)
            view.width.equalTo(box).dividedBy(2)
            view.height.equalTo(40)
        }
        
        registerTabLabel.snp.makeConstraints { view in
            view.center.equalTo(registerTab)
        }
        
        activityIndicator.snp.makeConstraints { view in
            view.center.equalTo(box)
        }
        
        // visible on login & registration tab
        
        emailTextField.snp.makeConstraints { view in
            view.top.equalTo(box).offset(40)
            view.centerX.equalToSuperview()
            view.height.equalTo(40)
            view.leading.equalTo(box).offset(15)
            view.trailing.equalTo(box).inset(15)
        }
        
        passwordTextField.snp.makeConstraints { view in
            view.top.equalTo(emailTextField.snp.bottom).offset(10)
            view.centerX.equalToSuperview()
            view.height.equalTo(40)
            view.leading.equalTo(box).offset(15)
            view.trailing.equalTo(box).inset(15)
        }
        
        loginButton.snp.makeConstraints { button in
            button.centerX.equalToSuperview()
            button.height.equalTo(40)
            button.leading.equalTo(box).offset(15)
            button.trailing.equalTo(box).inset(15)
            button.centerY.equalTo(registerButton)
        }
        
        // visible on registration tab only
        
        nameTextField.snp.makeConstraints { view in
            view.top.equalTo(passwordTextField.snp.bottom).offset(10)
            view.centerX.equalToSuperview()
            view.height.equalTo(40)
            view.leading.equalTo(box).offset(15)
            view.trailing.equalTo(box).inset(15)
        }
        
        studentIDTextField.snp.makeConstraints { view in
            view.top.equalTo(nameTextField.snp.bottom).offset(10)
            view.centerX.equalToSuperview()
            view.height.equalTo(40)
            view.leading.equalTo(box).offset(15)
            view.trailing.equalTo(box).inset(15)
        }
        
        classTextField.snp.makeConstraints { view in
            view.top.equalTo(studentIDTextField.snp.bottom).offset(10)
            view.centerX.equalToSuperview()
            view.height.equalTo(40)
            view.leading.equalTo(box).offset(15)
            view.trailing.equalTo(box).inset(15)
        }
        
        registerButton.snp.makeConstraints { button in
            button.top.equalTo(classTextField.snp.bottom).offset(40)
            button.centerX.equalToSuperview()
            button.height.equalTo(40)
            button.leading.equalTo(box).offset(15)
            button.trailing.equalTo(box).inset(15)
            button.bottom.equalTo(box).inset(40)
        }
    }
    
    // MARK: - Animation
    
    func hoverCloud() {
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.logoPic.transform = CGAffineTransform(translationX: 0, y: -1.5)
            self.logoOverlay.transform = CGAffineTransform(translationX: 0, y: -1.5)
            self.logoOverlay.alpha = 0
        }, completion: { finish in
            self.logoPic.transform = CGAffineTransform(translationX: 0, y: 1.5)
            self.logoOverlay.transform = CGAffineTransform(translationX: 0, y: 1.5)
            self.logoOverlay.isOpaque = true
        })
    }
    
    // MARK: - Button Actions and Functions
    
    func checkLogin() {
        if let currentUser = FIRAuth.auth()?.currentUser {
            //            self.present(TabViewController, animated: true)
            self.fillInSingleton(currentUser.uid)
            self.present(self.TabViewController, animated: true)
            self.navigationController?.navigationBar.isHidden = false
        }
    }
    
    func signInCredentials() -> (name: String, email: String, password: String, studentClass: String, studentID: String)? {
        guard let password = passwordTextField.text,
            let email = emailTextField.text,
            let name = nameTextField.text,
            let studentClass = classTextField.text,
            let studentID = studentIDTextField.text else { return nil }
        return (name, email, password, studentClass, studentID)
    }
    
    func showAlert(title: String, _ errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okayButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setUpDatabaseReference() {
        guard let credentials = signInCredentials() else { return }
        var databaseCodeForClass = ""
        let currentUser = FIRAuth.auth()!.currentUser!.uid
        let referenceLink = databaseReference.child("users").child(currentUser)
        
        // 1) Find out if a class exists, or generate it
        let classBuckets = databaseReference.child("classes")
        classBuckets.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var containsClass = false
            
            // 2) Loops through every snapshot in the Classes node to see if user's class exists
            for child in snapshot.children {
                if let snap = child as? FIRDataSnapshot,
                    let valueDict = snap.value as? [String : Any] {
                    
                    if let name = valueDict["name"] as? String {
                        if name == credentials.studentClass {
                            
                            // 2A) It exists! Set up the user, fills in the singleton, and break the loop
                            containsClass = true
                            databaseCodeForClass = snap.key
                            
                            let dict = [
                                "studentName" : credentials.name,
                                "studentEmail" : credentials.email,
                                "class" : credentials.studentClass,
                                "classKey" : databaseCodeForClass,
                                "studentID" : credentials.studentID
                            ]
                            
                            referenceLink.setValue(dict)
                            self.fillInSingleton(currentUser)
                            break
                        }
                    }
                }
            }
            
            // 3) Looks like we can't find the class. Time to create a ref for it in the database
            if !containsClass {
                let newClassRef = classBuckets.childByAutoId()
                let className = credentials.studentClass
                newClassRef.setValue(["name" : className]) { (error, reference) in
                    
                    // 3A) Looks like the ref was created. Time to finish up the rest of the user creation in database.
                    if error == nil {
                        print("\n\n\n\n Class \(className) doesn't exist! Created at \\classes\\\(reference.key)")
                        databaseCodeForClass = reference.key
                        
                        let dict = [
                            "studentName" : credentials.name,
                            "studentEmail" : credentials.email,
                            "class" : credentials.studentClass,
                            "classKey" : databaseCodeForClass,
                            "studentID" : credentials.studentID
                        ]
                        
                        referenceLink.setValue(dict)
                        self.fillInSingleton(currentUser)
                    }
                }
            } else {
                print("\n\n\n\n Class \(credentials.studentClass) exists already! It's at \\classes\\\(databaseCodeForClass)")
            }
        })
    }
    
    func fillInSingleton(_ string: String) {
        let user = databaseReference.child("users").child(string)
        user.observeSingleEvent(of: .value, with: { (snapshot) in
            if let valueDict = snapshot.value as? [String : Any] {
                let user = User.manager
                user.classroom = valueDict["class"] as? String
                user.classDatabaseKey = valueDict["classKey"] as? String
                user.email = valueDict["studentEmail"] as? String
                user.id = valueDict["studentID"] as? String
                user.name = valueDict["studentName"] as? String
                user.studentKey = string
                
                DispatchQueue.main.async {
                    // Load tab bar now!
                    self.fillInClassSingleton(user.classDatabaseKey)
                }
            }
        })
    }
    
    func fillInClassSingleton(_ classKey: String?) {
        if let key = classKey {
            let classRef = databaseReference.child("classes").child(key)
            classRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let valueDict = snapshot.value as? [String : Any] {
                    let thisClass = MyClass.manager
                    thisClass.studentGradesID = valueDict["studentGradesID"] as? String
                    thisClass.gradeBookID = valueDict["gradeBookID"] as? String
                    thisClass.lessonScheduleID = valueDict["lessonScheduleID"] as? String
                    thisClass.announcementsID = valueDict["announcementsID"] as? String
                    thisClass.assignmentsID = valueDict["assignmentsID"] as? String
                    thisClass.achievementsID = valueDict["achievementsID"] as? String
                    
                    DispatchQueue.main.async {
                        self.loadTabsAndEverythingElse()
                    }
                }
            })
        }
    }
    
    func loginButtonWasPressed() {
        AudioServicesPlaySystemSound(1105)
        UIView.animate(withDuration: 0.5, animations: {
            self.loginButton.layer.shadowOpacity = 0.1
            self.loginButton.layer.shadowRadius = 1
            self.loginButton.apply(gradient: [UIColor.weLearnGrey.withAlphaComponent(0.1), UIColor.weLearnCoolWhite])
        }, completion: { finish in
            self.loginButton.layer.shadowOpacity = 0.25
            self.loginButton.layer.shadowRadius = 2
            self.loginButton.layer.sublayers!.remove(at: 0)
        })
        
        guard let credentials = signInCredentials() else { return }
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        FIRAuth.auth()?.signIn(withEmail: credentials.email, password: credentials.password, completion: { (user, error) in
            
            if let loggedInUser = user {
                self.fillInSingleton(loggedInUser.uid)
                self.passwordTextField.text = ""
                self.activityIndicator.stopAnimating()
                self.present(self.TabViewController, animated: true)
                self.navigationController?.navigationBar.isHidden = false
            }
            
            let userID = FIRAuth.auth()?.currentUser?.uid
            let userDefaults = UserDefaults(suiteName: "group.com.welearn.app")
            userDefaults?.setValue(userID, forKey: "studentInfo")
            
            if let error = error {
                self.showAlert(title: "Login error", error.localizedDescription)
                self.activityIndicator.stopAnimating()
            }
        })
        
    }
    
    func registerButtonWasPressed() {
        AudioServicesPlaySystemSound(1105)
        UIView.animate(withDuration: 0.5, animations: {
            self.registerButton.layer.shadowOpacity = 0.1
            self.registerButton.layer.shadowRadius = 1
            self.registerButton.apply(gradient: [UIColor.weLearnGrey.withAlphaComponent(0.1), UIColor.weLearnCoolWhite])
        }, completion: { finish in
            self.registerButton.layer.shadowOpacity = 0.25
            self.registerButton.layer.shadowRadius = 2
            self.registerButton.layer.sublayers!.remove(at: 0)
        })
        
        guard let credentials = signInCredentials() else { return }
        
        activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        FIRAuth.auth()?.createUser(withEmail: credentials.email, password: credentials.password, completion: { (user, error) in
            if error == nil {
                self.signedInUser = user
                self.setUpDatabaseReference()
                self.registerButton.isEnabled = false
                
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.checkTime), userInfo: nil, repeats: true)
                self.timer.fire()
                
                UIView.animate(withDuration: 0.5) {
                    var scaleAndFloat = CGAffineTransform.identity
                    scaleAndFloat = scaleAndFloat.scaledBy(x: 1.5, y: 1.5)
                    scaleAndFloat = scaleAndFloat.translatedBy(x: 0, y: -20)
                    self.registerButton.transform = scaleAndFloat
                    self.registerButton.alpha = 0
                    self.loginButton.isHidden = false
                    self.loginButton.isEnabled = true
                }
                
                let userID = user?.uid
                let userDefaults = UserDefaults(suiteName: "group.com.welearn.app")
                userDefaults?.setValue(userID, forKey: "studentInfo")
            }
            
            if let error = error {
                self.showAlert(title: "Registering Error", error.localizedDescription)
                
                self.registerButton.isEnabled = true
                self.registerButton.transform = .identity
                self.loginButton.isHidden = true
                self.loginButton.isEnabled = false
                
                self.activityIndicator.stopAnimating()
            }
        })
    }
    
    func checkTime () {
        if self.time >= 0.5  {
            self.present(TabViewController, animated: true)
            timer.invalidate()
        }
        
        self.time += 0.1
    }
    
    func registerTabWasPressed() {
        AudioServicesPlaySystemSound(1104)
        UIView.animate(withDuration: 0.5, animations: {
            self.registerTab.layer.shadowOpacity = 0.1
            self.registerTab.layer.shadowRadius = 1
            self.registerTab.apply(gradient: [UIColor.weLearnGrey.withAlphaComponent(0.2), UIColor.weLearnCoolWhite])
        }, completion: { finish in
            self.registerTab.layer.shadowOpacity = 0.25
            self.registerTab.layer.shadowRadius = 2
            self.registerTab.layer.sublayers!.remove(at: 0)
        })
        
        registerTab.isSelected = true
        loginTab.isSelected = false
        colorTab(button1: registerTab, button2: loginTab)
        
        registerButton.isEnabled = true
        registerTabLabel.textColor = UIColor.weLearnBlue
        loginTabLabel.textColor = UIColor.weLearnBlue.withAlphaComponent(0.6)
        toggleIsHiddenWhenTabIsChanged.map { $0.isHidden = false }
    }
    
    func loginTabWasPressed() {
        AudioServicesPlaySystemSound(1104)
        UIView.animate(withDuration: 0.5, animations: {
            self.loginTab.layer.shadowOpacity = 0.1
            self.loginTab.layer.shadowRadius = 1
            self.loginTab.apply(gradient: [UIColor.weLearnGrey.withAlphaComponent(0.2), UIColor.weLearnCoolWhite])
        }, completion: { finish in
            self.loginTab.layer.shadowOpacity = 0.25
            self.loginTab.layer.shadowRadius = 2
            self.loginTab.layer.sublayers!.remove(at: 0)
        })
        
        loginTab.isSelected = true
        registerTab.isSelected = false
        colorTab(button1: loginTab, button2: registerTab)
        
        loginButton.isEnabled =  true
        loginTabLabel.textColor = UIColor.weLearnBlue
        registerTabLabel.textColor = UIColor.weLearnBlue.withAlphaComponent(0.6)
        
        toggleIsHiddenWhenTabIsChanged.map { $0.isHidden = true }
    }
    
    // MARK: - Views created here
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        view.hidesWhenStopped = true
        view.color = UIColor.weLearnGreen
        return view
    }()
    
    lazy var logoPic: UIImageView = {
        let view = UIImageView()
        let originalImage = #imageLiteral(resourceName: "logoForSplash")
        let templateImage = originalImage.withRenderingMode(.alwaysTemplate)
        view.image = templateImage
        view.tintColor = UIColor.white
        view.layer.shadowColor = UIColor.weLearnBlack.cgColor
        view.layer.shadowOffset = CGSize(width: -5, height: 5)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 1
        view.layer.shouldRasterize = true
        view.layer.masksToBounds = false
        return view
    }()
    
    lazy var logoOverlay: UIImageView = {
        let view = UIImageView()
        let originalImage = #imageLiteral(resourceName: "logoForSplash")
        let templateImage = originalImage.withRenderingMode(.alwaysTemplate)
        view.image = templateImage
        view.tintColor = UIColor(red:0.30, green:0.51, blue:0.69, alpha:1.0).withAlphaComponent(0.2)
        view.layer.masksToBounds = false
        return view
    }()
    
    lazy var loginTab: Box = {
        let button = Box()
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(loginTabWasPressed), for: .touchUpInside)
        button.isSelected = true
        return button
    }()
    
    lazy var registerTab: Box = {
        let button = Box()
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(registerTabWasPressed), for: .touchUpInside)
        button.isSelected = false
        return button
    }()
    
    lazy var loginTabLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Black", size: 20)
        label.textColor = UIColor.weLearnBlue
        label.text = "LOGIN"
        return label
    }()
    
    lazy var registerTabLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Black", size: 20)
        label.textColor = UIColor.weLearnBlue.withAlphaComponent(0.6)
        label.text = "REGISTER"
        return label
    }()
    
    lazy var box: Box = {
        let button = Box()
        button.backgroundColor = UIColor.white
        return button
    }()
    
    lazy var emailTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.placeholder = "Email"
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    lazy var passwordTextField: PaddedTextField = {
        let secondTextField = PaddedTextField()
        secondTextField.placeholder = "Password"
        secondTextField.isSecureTextEntry = true
        secondTextField.spellCheckingType = .no
        secondTextField.autocorrectionType = .no
        secondTextField.autocapitalizationType = .none
        return secondTextField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.weLearnCoolWhite
        button.layer.borderColor = UIColor.weLearnBlue.cgColor
        button.layer.borderWidth = 2
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 20)
        button.setTitle("Login".uppercased(), for: .normal)
        button.setTitleColor(UIColor.weLearnBlue, for: .normal)
        button.addTarget(self, action: #selector(loginButtonWasPressed), for: .touchUpInside)
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.25
        button.layer.shadowRadius = 2
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.weLearnCoolWhite
        button.layer.borderColor = UIColor.weLearnBlue.cgColor
        button.layer.borderWidth = 2
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 20)
        button.setTitle("register".uppercased(), for: .normal)
        button.setTitleColor(UIColor.weLearnBlue, for: .normal)
        button.addTarget(self, action: #selector(registerButtonWasPressed), for: .touchUpInside)
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.25
        button.layer.shadowRadius = 2
        return button
    }()
    
    lazy var nameTextField: PaddedTextField = {
        let thirdTextfield = PaddedTextField()
        thirdTextfield.placeholder = "Preferred name"
        thirdTextfield.isSecureTextEntry = false
        thirdTextfield.spellCheckingType = .no
        thirdTextfield.autocorrectionType = .no
        thirdTextfield.autocapitalizationType = .none
        return thirdTextfield
    }()
    
    lazy var classTextField: PaddedTextField = {
        let fourthTextfield = PaddedTextField()
        fourthTextfield.placeholder = "Class"
        fourthTextfield.isSecureTextEntry = false
        fourthTextfield.spellCheckingType = .no
        fourthTextfield.autocorrectionType = .no
        fourthTextfield.autocapitalizationType = .none
        return fourthTextfield
    }()
    
    lazy var studentIDTextField: PaddedTextField = {
        let fifthTextfield = PaddedTextField()
        fifthTextfield.placeholder = "Student ID"
        fifthTextfield.isSecureTextEntry = true
        fifthTextfield.spellCheckingType = .no
        fifthTextfield.autocorrectionType = .no
        fifthTextfield.autocapitalizationType = .none
        return fifthTextfield
    }()
    
}
