//
//  OldAnnouncementTableViewController.swift
//  weLearn
//
//  Created by Karen Fuentes on 2/27/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import SnapKit
import AudioToolbox
import FirebaseAuth
import FirebaseStorage

class AnnouncementsTableViewController: UITableViewController {
    
    fileprivate let reuseIdentifier = "AnnouncementCell"
    
    let announcementSheetID = MyClass.manager.announcementsID!
    var announcements: [Announcement]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Announcements"
        self.tabBarController?.title = navigationItem.title
        
        tableView.register(AnnouncementTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 268.0
        
        tableView.separatorStyle = .none
        
        self.view.addSubview(activityIndicator)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.snp.makeConstraints { view in
            view.center.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if announcements == nil {
            getAnnouncements()
        }
    }
    
    func getAnnouncements() {
        self.view.bringSubview(toFront: activityIndicator)
        activityIndicator.startAnimating()
        
        APIRequestManager.manager.getData(endPoint: "https://spreadsheets.google.com/feeds/list/\(announcementSheetID)/od6/public/basic?alt=json") { (data: Data?) in
            if data != nil {
                if let returnedAnnouncements = Announcement.getAnnouncements(from: data!) {
                    print("We've got returns: \(returnedAnnouncements.count)")
                    self.announcements = returnedAnnouncements.sorted(by: { $0.date > $1.date })
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.tableView.reloadData()
                    }
                }
            } else {
                print("error loading data!")
                self.activityIndicator.stopAnimating()
            }
        }
    }
    

    
    // MARK: - Actions
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AudioServicesPlaySystemSound(1103)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcements?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AnnouncementTableViewCell
        cell.selectionStyle = .none
        
        if let announce = announcements {
            cell.date.text = announce[indexPath.row].dateString
            cell.quote.text = announce[indexPath.row].quote
            cell.author.text = announce[indexPath.row].author
        }
        
        return cell
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        return view
    }()
}
