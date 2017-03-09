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
import FirebaseDatabase

class InitialViewController: UIViewController {
    
    var databaseReference = FIRDatabase.database()
    var databaseObserver: FIRDatabaseHandle?
    var signedInUser: FIRUser?
    
    var toggleIsHiddenWhenTabIsChanged = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // self.view.apply(gradient: [UIColor.white, UIColor(red:0.30, green:0.51, blue:0.69, alpha:1.0).withAlphaComponent(0.5), UIColor(red:0.30, green:0.51, blue:0.69, alpha:1.0)])
        self.view.apply(gradient: [UIColor.weLearnGreen.withAlphaComponent(0.5), UIColor.white, UIColor.weLearnGreen.withAlphaComponent(0.5)])

        
        viewHiearchy()
        configureConstraints()
        
        registerTab.backgroundColor = UIColor.weLearnLightGreen
        
        toggleIsHiddenWhenTabIsChanged = [
            registerButton,
            nameTextField,
            nameStripe,
            nameBar,
            classTextField,
            classStripe,
            classBar,
            studentIDTextField,
            studentIDStripe,
            studentIDBar
        ]
        
        toggleIsHiddenWhenTabIsChanged.map { $0.isHidden = true }
    }
    
    func colorTab(_ button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            button.backgroundColor = UIColor.white
            //button.titleLabel?.textColor = UIColor.weLearnGreen
        } else {
            button.backgroundColor = UIColor.weLearnLightGreen
            //button.titleLabel?.textColor = UIColor.weLearnGrey
        }
    }
    
    func viewHiearchy() {
        self.view.addSubview(logoPic)
        self.view.addSubview(logoOverlay)
        // self.view.addSubview(logoHeader)
        self.view.addSubview(registerTab)
        self.view.addSubview(registerTabLabel)
        self.view.addSubview(loginTab)
        self.view.addSubview(loginTabLabel)
        self.view.addSubview(box)
        self.view.addSubview(nameTextField)
        self.view.addSubview(nameStripe)
        self.view.addSubview(nameBar)
        self.view.addSubview(classTextField)
        self.view.addSubview(classStripe)
        self.view.addSubview(classBar)
        self.view.addSubview(studentIDTextField)
        self.view.addSubview(studentIDStripe)
        self.view.addSubview(studentIDBar)
        self.view.addSubview(emailTextField)
        self.view.addSubview(emailStripe)
        self.view.addSubview(emailBar)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(passwordStripe)
        self.view.addSubview(passwordBar)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
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
        
//        logoHeader.snp.makeConstraints { label in
//            label.top.equalToSuperview().offset(40)
//            label.leading.equalToSuperview().offset(25)
//        }
        
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
        
        // visible on login & registration tab
        
        emailTextField.snp.makeConstraints { view in
            view.top.equalTo(box).offset(40)
            view.centerX.equalToSuperview()
            view.height.equalTo(40)
            view.leading.equalTo(box).offset(15)
            view.trailing.equalTo(box).inset(15)
        }
        
        emailStripe.snp.makeConstraints { view in
            view.width.equalTo(emailTextField)
            view.trailing.equalTo(emailTextField)
            view.height.equalTo(2)
            view.top.equalTo(emailTextField.snp.bottom)
        }
        
        emailBar.snp.makeConstraints { view in
            view.top.equalTo(emailTextField)
            view.bottom.equalTo(emailTextField)
            view.width.equalTo(2)
            view.leading.equalTo(emailTextField)
        }
        
        passwordTextField.snp.makeConstraints { view in
            view.top.equalTo(emailTextField.snp.bottom).offset(10)
            view.centerX.equalToSuperview()
            view.height.equalTo(40)
            view.leading.equalTo(box).offset(15)
            view.trailing.equalTo(box).inset(15)
        }
        
        passwordStripe.snp.makeConstraints { view in
            view.leading.equalTo(passwordTextField)
            view.trailing.equalTo(passwordTextField)
            view.height.equalTo(2)
            view.top.equalTo(passwordTextField.snp.bottom)
        }
        
        passwordBar.snp.makeConstraints { view in
            view.top.equalTo(passwordTextField)
            view.bottom.equalTo(passwordTextField)
            view.width.equalTo(2)
            view.leading.equalTo(passwordTextField)
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
        
        nameStripe.snp.makeConstraints { view in
            view.width.equalTo(nameTextField)
            view.trailing.equalTo(nameTextField)
            view.height.equalTo(2)
            view.top.equalTo(nameTextField.snp.bottom)
        }
        
        nameBar.snp.makeConstraints { view in
            view.top.equalTo(nameTextField)
            view.bottom.equalTo(nameTextField)
            view.width.equalTo(2)
            view.leading.equalTo(nameTextField)
        }
        
        studentIDTextField.snp.makeConstraints { view in
            view.top.equalTo(nameTextField.snp.bottom).offset(10)
            view.centerX.equalToSuperview()
            view.height.equalTo(40)
            view.leading.equalTo(box).offset(15)
            view.trailing.equalTo(box).inset(15)
        }
        
        studentIDStripe.snp.makeConstraints { view in
            view.width.equalTo(studentIDTextField)
            view.trailing.equalTo(studentIDTextField)
            view.height.equalTo(2)
            view.top.equalTo(studentIDTextField.snp.bottom)
        }
        
        studentIDBar.snp.makeConstraints { view in
            view.top.equalTo(studentIDTextField)
            view.bottom.equalTo(studentIDTextField)
            view.width.equalTo(2)
            view.leading.equalTo(studentIDTextField)
        }
        
        classTextField.snp.makeConstraints { view in
            view.top.equalTo(studentIDTextField.snp.bottom).offset(10)
            view.centerX.equalToSuperview()
            view.height.equalTo(40)
            view.leading.equalTo(box).offset(15)
            view.trailing.equalTo(box).inset(15)
        }
        
        classStripe.snp.makeConstraints { view in
            view.width.equalTo(classTextField)
            view.trailing.equalTo(classTextField)
            view.height.equalTo(2)
            view.top.equalTo(classTextField.snp.bottom)
        }
        
        classBar.snp.makeConstraints { view in
            view.top.equalTo(classTextField)
            view.bottom.equalTo(classTextField)
            view.width.equalTo(2)
            view.leading.equalTo(classTextField)
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
    
    // MARK: - Button Actions
    
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
        
        
        let referenceLink = databaseReference.reference().child(credentials.studentClass)
        
        let dict = [
            "studentName" : credentials.name,
            "studentEmail" : credentials.email,
            "class" : credentials.studentClass,
            "studentID" : credentials.studentID
        ]
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(dict, forKey: "studentInfo")
        
        referenceLink.setValue(dict)

    }
    
    func loginButtonWasPressed() {
        guard let credentials = signInCredentials() else { return }
        FIRAuth.auth()?.signIn(withEmail: credentials.email, password: credentials.password, completion: { (user, error) in
            
            if user != nil {
                
                self.present(UINavigationController(rootViewController: HomeViewController()), animated: false)
            }
            
            if let error = error {
                self.showAlert(title: "Login error", error.localizedDescription)
            }
            
        })
    }
    
    func registerButtonWasPressed() {
        guard let credentials = signInCredentials() else { return }
        FIRAuth.auth()?.createUser(withEmail: credentials.email, password: credentials.password, completion: { (user, error) in
            if user != nil {
                self.signedInUser = user
                self.setUpDatabaseReference()
                self.registerButton.isEnabled = false
                UIView.animate(withDuration: 1) {
                    var scaleAndFloat = CGAffineTransform.identity
                    scaleAndFloat = scaleAndFloat.scaledBy(x: 1.5, y: 1.5)
                    scaleAndFloat = scaleAndFloat.translatedBy(x: 0, y: -20)
                    self.registerButton.transform = scaleAndFloat
                    self.registerButton.alpha = 0
                    self.loginButton.isHidden = false
                    self.loginButton.isEnabled = true
                }
            }
            if let error = error {
                self.showAlert(title: "Registering Error", error.localizedDescription)
                self.registerButton.isEnabled = true
                self.registerButton.transform = .identity
                self.loginButton.isHidden = true
                self.loginButton.isEnabled = false
            }
        })
    }
    
    func registerTabWasPressed() {
        colorTab(registerTab)
        colorTab(loginTab)
        
        registerButton.isEnabled = true
        registerTabLabel.textColor = UIColor.weLearnGreen
        loginTabLabel.textColor = UIColor.weLearnGreen.withAlphaComponent(0.6)
        
        toggleIsHiddenWhenTabIsChanged.map { $0.isHidden = false }
    }
    
    func loginTabWasPressed() {
        colorTab(registerTab)
        colorTab(loginTab)
        
        loginButton.isEnabled =  true
        loginTabLabel.textColor = UIColor.weLearnGreen
        registerTabLabel.textColor = UIColor.weLearnGreen.withAlphaComponent(0.6)
        
        toggleIsHiddenWhenTabIsChanged.map { $0.isHidden = true }
    }
    
    // MARK: - Views created here
    
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
        view.layer.masksToBounds = false
        return view
    }()
    
    lazy var logoOverlay: UIImageView = {
        let view = UIImageView()
        let originalImage = #imageLiteral(resourceName: "logoForSplash")
        let templateImage = originalImage.withRenderingMode(.alwaysTemplate)
        view.image = templateImage
        view.tintColor = UIColor(red:0.30, green:0.51, blue:0.69, alpha:1.0).withAlphaComponent(0.1)
        view.layer.masksToBounds = false
        return view
    }()
    
//    lazy var logoHeader: UIOutlinedLabel = {
//        let label = UIOutlinedLabel()
//        label.text = "We \nLearn"
//        label.font = UIFont(name: "Thirtysix", size: 72)
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
//        label.textColor = UIColor.white
//        label.layer.shadowColor = UIColor.weLearnGreen.cgColor
//        label.layer.shadowOffset = CGSize(width: -10, height: 10)
//        label.layer.shadowOpacity = 1
//        label.layer.shadowRadius = 1
//        label.layer.masksToBounds = false
//        return label
//    }()
    
    lazy var loginTab: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: -2, height: 3)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 3
        button.layer.masksToBounds = false
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 20)
        // button.setTitle("Login".uppercased(), for: .normal)
//        button.setTitleColor(UIColor.weLearnGreen, for: .selected)
//        button.setTitleColor(UIColor.weLearnGrey, for: .normal)
        button.addTarget(self, action: #selector(loginTabWasPressed), for: .touchUpInside)
        button.isSelected = true
        return button
    }()
    
    lazy var registerTab: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: -2, height: 3)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 3
        button.layer.masksToBounds = false
//        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 20)
//        button.setTitle("Register".uppercased(), for: .normal)
//        button.setTitleColor(UIColor.weLearnGreen, for: .selected)
//        button.setTitleColor(UIColor.weLearnGrey, for: .normal)
        button.addTarget(self, action: #selector(registerTabWasPressed), for: .touchUpInside)
        button.isSelected = false
        return button
    }()
    
    lazy var loginTabLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Black", size: 20)
        label.textColor = UIColor.weLearnGreen
        label.text = "LOGIN"
        return label
    }()
    
    lazy var registerTabLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Black", size: 20)
        label.textColor = UIColor.weLearnGreen.withAlphaComponent(0.6)
        label.text = "REGISTER"
        return label
    }()
    
    lazy var box: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: -2, height: 3)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 3
        view.layer.masksToBounds = false
        return view
    }()
    
    lazy var emailTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.placeholder = "Email"
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    lazy var emailStripe: UIView = {
        let stripe = UIView()
        stripe.backgroundColor = UIColor.weLearnGreen
        return stripe
    }()
    
    lazy var emailBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor.weLearnGreen
        return bar
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
    
    lazy var passwordStripe: UIView = {
        let secondStripe = UIView()
        secondStripe.backgroundColor = UIColor.weLearnGreen
        return secondStripe
    }()
    
    lazy var passwordBar: UIView = {
        let secondBar = UIView()
        secondBar.backgroundColor = UIColor.weLearnGreen
        return secondBar
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.weLearnCoolWhite
        button.layer.borderColor = UIColor.weLearnGreen.cgColor
        button.layer.borderWidth = 2
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 20)
        button.setTitle("Login".uppercased(), for: .normal)
        button.setTitleColor(UIColor.weLearnGreen, for: .normal)
        button.addTarget(self, action: #selector(loginButtonWasPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.weLearnCoolWhite
        button.layer.borderColor = UIColor.weLearnGreen.cgColor
        button.layer.borderWidth = 2
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 20)
        button.setTitle("register".uppercased(), for: .normal)
        button.setTitleColor(UIColor.weLearnGreen, for: .normal)
        button.addTarget(self, action: #selector(registerButtonWasPressed), for: .touchUpInside)
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
    
    lazy var nameStripe: UIView = {
        let stripe = UIView()
        stripe.backgroundColor = UIColor.weLearnGreen
        return stripe
    }()
    
    lazy var nameBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor.weLearnGreen
        return bar
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
    
    lazy var classStripe: UIView = {
        let stripe = UIView()
        stripe.backgroundColor = UIColor.weLearnGreen
        return stripe
    }()
    
    lazy var classBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor.weLearnGreen
        return bar
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
    
    lazy var studentIDStripe: UIView = {
        let stripe = UIView()
        stripe.backgroundColor = UIColor.weLearnGreen
        return stripe
    }()
    
    lazy var studentIDBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor.weLearnGreen
        return bar
    }()

}
