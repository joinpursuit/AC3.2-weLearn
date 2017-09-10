//
//  LinksTableViewController.swift
//  weLearn
//
//  Created by Karen Fuentes on 3/9/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SafariServices
import AudioToolbox

class LinkTableViewController: UITableViewController, Tappable, SFSafariViewControllerDelegate {
    
    let databaseReference = Database.database().reference()
    var links: [Link]! = []
    var imageDict = [String : UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Links"
        self.tabBarController?.title = navigationItem.title
        
        tableView.register(LinkTableViewCell.self, forCellReuseIdentifier: "LinkTableViewCell")
        
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
        
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        self.getDataInfo()
    }
    
    func getDataInfo() {
        self.view.bringSubview(toFront: activityIndicator)
        activityIndicator.startAnimating()
        
        databaseReference.child("links").child(Student.manager.classDatabaseKey!).observeSingleEvent(of: .value, with: { (snapShot) in
            guard let value = snapShot.value as? [String : Any] else { return }
            var linksArr = [Link]()
            for link in value {
                guard let dict = link.value as? [String : Any] else { return }
                guard let links = Link(fromDict: dict) else { return }
                linksArr.append(links)
            }
            self.links = linksArr
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
            print(">>> there are \(self.links.count) links")
        }) { (error) in
            print(error.localizedDescription)
            self.activityIndicator.stopAnimating()
        }
    }
    
    func getProfileImage(_ id: String) -> UIImage? {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("profileImage/\(id)")
        
        imageRef.getData(maxSize: 1*1024*1024) { (data, error) in
            if let error = error {
                print(error)
            }
            else {
                let image = UIImage(data: data!)
                self.imageDict[id] = image
            }
        }
        
        return self.imageDict[id] ?? nil
    }
    
    func checkForImage(_ id: String) -> UIImage? {
        if imageDict[id] != nil {
            return imageDict[id]
        }
        else {
            return getProfileImage(id)
        }
    }
    
    // MARK: - Button stuff
    
    func cellTapped(cell: UITableViewCell) {
        AudioServicesPlaySystemSound(1105)
        self.urlButtonClicked(at: tableView.indexPath(for: cell)!)
    }
    
    func urlButtonClicked(at index: IndexPath) {
        let url = URL(string: links[index.row].url)!
        let svc = SFSafariViewController(url: url)
        
        let currentCell = tableView.cellForRow(at: index) as! LinkTableViewCell
        
        UIView.animate(withDuration: 0.5, animations: {
            currentCell.box.layer.shadowOpacity = 0.1
            currentCell.box.layer.shadowRadius = 1
            currentCell.box.apply(gradient: [UIColor.weLearnGrey.withAlphaComponent(0.1), UIColor.weLearnCoolWhite])
        }, completion: { finish in
            currentCell.box.layer.shadowOpacity = 0.25
            currentCell.box.layer.shadowRadius = 2
            currentCell.box.layer.sublayers!.remove(at: 0)
        })
        
        navigationController?.show(svc, sender: self)
        svc.delegate = self
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkTableViewCell", for: indexPath) as! LinkTableViewCell
        cell.selectionStyle = .none
        
        if cell.delegate == nil {
            cell.delegate = self
        }
        
        let linkAtRow = links[indexPath.row]
        cell.authorLabel.text = linkAtRow.author
        cell.descriptionLabel.text = linkAtRow.description
        let colors = [UIColor(red:1.00, green:0.18, blue:0.33, alpha:1.0), UIColor(red:1.00, green:0.80, blue:0.00, alpha:1.0), UIColor(red:0.30, green:0.85, blue:0.39, alpha:1.0), UIColor.weLearnLightBlue]
        
        cell.profilePic.tintColor = colors[indexPath.row % colors.count]
        
        let userImage: UIImage? = checkForImage(linkAtRow.studentKey)
        
        if let profileImage = userImage {
            cell.profilePic.image = profileImage
        }
        
        return cell
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        return view
    }()
}
