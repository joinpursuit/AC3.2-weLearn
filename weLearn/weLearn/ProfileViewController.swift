//
//  ProfileViewController.swift
//  weLearn
//
//  Created by Marty Avedon on 3/7/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import AudioToolbox
import FirebaseDatabase
import MobileCoreServices

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    /* we shall make cells for the acheievements and grades
     grades will be a simple cell
     achievements will be a cell containing a collection view or scroll view
     */
    
    var achievements: [Achievement]? {
        didSet {
            User.manager.achievements = achievements
        }
    }
    var testGrades: TestGrade?
    var databaseReference: FIRDatabaseReference!
    var gradesParsed: [(assignment: String, grade: String)] = [] {
        didSet {
            User.manager.grades = gradesParsed
        }
    }
    
    var gradesSheetID = MyClass.manager.studentGradesID!
    var achievementsSheetID = MyClass.manager.achievementsID!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.title = "Profile"
        self.tabBarController?.title = navigationItem.title
        
        self.view.backgroundColor = UIColor.weLearnBlue
        
        viewHeirarchy()
        configureConstraints()
        
        self.edgesForExtendedLayout = .bottom
        
        tableView.register(GradeTableViewCell.self, forCellReuseIdentifier: "GradeTableViewCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 268.0
        
        profilePic.layer.cornerRadius = 50
        profilePic.clipsToBounds = true
        
        //        fakePopulate([Achievement(pic: "studentOfTheMonth", description: "Student Of The Month"), Achievement(pic: "academicExcellence", description: "Academic Excellence"), Achievement(pic: "studentOfTheMonth", description: "Great Coder"), Achievement(pic: "academicExcellence", description: "Best at Clapping"), Achievement(pic: "studentOfTheMonth", description: "Thumbs Up")])
        
        databaseReference = FIRDatabase.database().reference()
        
        if User.manager.studentKey != nil {
            getProfileImage()
        }
        
        let rightButton = UIBarButtonItem(customView: logOutButton)
        navigationItem.setRightBarButton(rightButton, animated: true)
        
        logOutButton.addTarget(self, action: #selector(logOutButtonWasPressed(selector:)), for: .touchUpInside)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        if profilePic.image == nil {
            uploadImageButton.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        startGrabbingTestData()
        getChievos()
    }
    
    func getChievos() {
        if User.manager.achievements == nil {
            APIRequestManager.manager.getData(endPoint: "https://spreadsheets.google.com/feeds/list/\(achievementsSheetID)/od6/public/basic?alt=json") { (data: Data?) in
                if data != nil {
                    if let returnedAnnouncements = AchievementBucket.getStudentAchievementBucket(from: data!, for: User.manager.id!) {
                        DispatchQueue.main.async {
                            self.achievements = AchievementBucket.parseBucketString(returnedAnnouncements.contentString)
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
        else {
            self.collectionView.reloadData()
        }
    }
    
    func getProfileImage() {
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("profileImage/\(User.manager.studentKey!)")
        
        imageRef.data(withMaxSize: 1*1024*1024) { (data, error) in
            if let error = error {
                print(error)
            }
            else {
                let image = UIImage(data: data!)
                self.profilePic.image = image
                self.uploadImageButton.setTitle("  ", for: .normal)
            }
        }
    }
    
    //MARK: - Views
    
    func viewHeirarchy() {
        self.view.addSubview(profileBox)
        self.view.addSubview(profilePic)
        self.view.addSubview(nameLabel)
        self.view.addSubview(emailLabel)
        self.view.addSubview(classLabel)
        self.view.addSubview(editButton)
        self.view.addSubview(tableView)
        self.view.addSubview(collectionView)
        self.view.addSubview(uploadImageButton)
    }
    
    func configureConstraints() {
        tableView.snp.makeConstraints { (tV) in
            tV.leading.trailing.bottom.equalToSuperview()
            tV.top.equalTo(collectionView.snp.bottom).offset(10)
        }
        
        collectionView.snp.makeConstraints { (cV) in
            cV.leading.trailing.equalToSuperview()
            cV.top.equalTo(profileBox.snp.bottom)
            cV.height.equalTo(150)
        }
        
        profileBox.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(10)
            view.centerX.equalToSuperview()
            view.leading.equalToSuperview().offset(25)
            view.trailing.equalToSuperview().inset(25)
        }
        
        uploadImageButton.snp.makeConstraints { (view) in
            view.top.leading.equalTo(profileBox).offset(10)
            view.width.height.equalTo(100)
            view.height.equalTo(profilePic.snp.width)
        }
        
        profilePic.snp.makeConstraints { view in
            view.top.leading.equalTo(profileBox).offset(10)
            view.width.height.equalTo(100)
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
        
    }
    
    //MARK: - User Functions
    
    func startGrabbingTestData() {
        if User.manager.grades == nil {
            APIRequestManager.manager.getData(endPoint: "https://spreadsheets.google.com/feeds/list/\(gradesSheetID)/od6/public/basic?alt=json") { (data: Data?) in
                if data != nil {
                    self.fetchStudentTestData(data!)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func fetchStudentTestData(_ data: Data) {
        
        // Now that we have the number, grab that person's grades
        if let studentID = User.manager.id {
            if let returnedGradesData = TestGrade.getStudentTestGrade(from: data,
                                                                      for: studentID) {
                print("\n\n\nWe've got grades for: \(returnedGradesData.id)")
                
                self.testGrades = returnedGradesData
                self.gradesParsed = TestGrade.parseGradeString(self.testGrades!.grades)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Collection view stuff
    
    // MARK: - UIImagePicker Delegate Method
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profilePic.image = image
            // let postRef = self.databaseReference.childByAutoId()
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://welearn-a2b14.appspot.com/")
            let spaceRef = storageRef.child("profileImage/\(User.manager.studentKey!)")
            
            let data = UIImageJPEGRepresentation(image, 0.5)
            let metaData = FIRStorageMetadata()
            metaData.cacheControl = "public,max-age=300";
            metaData.contentType = "image/jpeg";
            
            let _ = spaceRef.put(data!, metadata: metaData, completion: { (metaData, error) in
                guard metaData != nil else {
                    print("Error in putting data")
                    return
                }
            })
            
            print("appending \(image)")
        }
        
        dismiss(animated: true) {
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return User.manager.achievements?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AchievementCollectionViewCell", for: indexPath)
        
        if let achievementsUnwrapped = User.manager.achievements {
            if achievementsUnwrapped.count > 0 {
                if let achievementCell = cell as? AchievementCollectionViewCell {
                    achievementCell.achievementPic.image = UIImage(named: achievementsUnwrapped[indexPath.row].pic)
                    achievementCell.descriptionLabel.text = achievements?[indexPath.row].description
                }
            }
        }
        
        return cell
    }
    
    // MARK: - Table view stuff
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Grades"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let loadedGrades = User.manager.grades {
            return loadedGrades.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "GradeTableViewCell", for: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if let loadedGrades = User.manager.grades {
            if let gradeCell = cell as? GradeTableViewCell {
                let grades = loadedGrades[indexPath.row]
                gradeCell.testNameLabel.text = grades.assignment
                gradeCell.gradeLabel.text = grades.grade
                
                if (gradeCell.testNameLabel.text?.lowercased().contains("average"))! {
                    gradeCell.testNameLabel.font = UIFont(name: "Avenir-Black", size: 16)
                }
            }
        }
        
        cell.selectionStyle = .none
        cell.layer.shadowOffset = CGSize(width: 2, height: 3)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowRadius = 3
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    //Mark: - Button Functions
    
    func logOutButtonWasPressed(selector: UIButton) {
        AudioServicesPlaySystemSound(1105)
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                self.navigationController?.navigationBar.isHidden = true
                selector.isHidden = true
                self.dismiss(animated: true, completion: nil)
                User.logOut()
            }
                
            catch {
                print(error)
            }
        }
    }
    
    func uploadImageButtonWasTouched() {
        let picker = UIImagePickerController()
        uploadImageButton.alpha = 0
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [String(kUTTypeImage)]
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
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
        pic.layer.borderColor = UIColor.weLearnCoolWhite.cgColor
        //pic.image = #imageLiteral(resourceName: "Karen")
        pic.backgroundColor = UIColor.white
        pic.contentMode = .scaleAspectFit
        pic.layer.borderWidth = 3
        return pic
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.weLearnCoolWhite
        label.text = User.manager.name ?? "Anon"
        label.font = UIFont(name: "Avenir-Light", size: 24)
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.weLearnCoolWhite
        label.text = User.manager.email ?? "anon@anon.com"
        label.font = UIFont(name: "Avenir-Roman", size: 16)
        return label
    }()
    
    lazy var classLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.weLearnCoolWhite
        label.text = User.manager.classroom ?? "No class"
        label.font = UIFont(name: "Avenir-Roman", size: 16)
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView() //(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.estimatedItemSize = CGSize(width: 50, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AchievementCollectionViewCell.self, forCellWithReuseIdentifier: "AchievementCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var uploadImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Upload A Pic", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 12)
        button.setTitleColor(UIColor.weLearnBlue, for: .normal)
        button.addTarget(self, action: #selector(uploadImageButtonWasTouched), for: .touchUpInside)
        return button
    }()
    
    lazy var logOutButton: ShinyOvalButton = {
        let button = ShinyOvalButton()
        button.setTitle("Log Out".uppercased(), for: .normal)
        button.setTitleColor(UIColor.weLearnBlue, for: .normal)
        button.layer.cornerRadius = 15
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        button.imageView?.clipsToBounds = true
        return button
    }()
}
