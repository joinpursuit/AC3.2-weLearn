//
//  OldAnnouncementTableViewController.swift
//  weLearn
//
//  Created by Karen Fuentes on 2/27/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class OldAnnouncementsTableViewController: UITableViewController {
    
    fileprivate let reuseIdentifier = "AnnouncementCell"
    
    let announcementSheetID = MyClass.manager.announcementsID!
    var announcements: [Announcement]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Announcements"
        self.tabBarController?.title = navigationItem.title
        
        // navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        // linksButton.addTarget(self, action: #selector(buttonWasPressed(button:)), for: .touchUpInside)
        // let rightButton = UIBarButtonItem(customView: linksButton)
        // navigationItem.setRightBarButton(rightButton, animated: true)
        
        tableView.register(AnnouncementTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 268.0
        
        tableView.separatorStyle = .none

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getAnnouncements()
    }
    
    func getAnnouncements() {
        APIRequestManager.manager.getData(endPoint: "https://spreadsheets.google.com/feeds/list/\(announcementSheetID)/od6/public/basic?alt=json") { (data: Data?) in
            if data != nil {
                if let returnedAnnouncements = Announcement.getAnnouncements(from: data!) {
                    print("We've got returns: \(returnedAnnouncements.count)")
                    self.announcements = returnedAnnouncements.sorted(by: { $0.date > $1.date })
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    
    //    func buttonWasPressed(button: UIButton) {
    //        //    navigationController?.pushViewController(LinksCollectionViewController(), animated: true)
    //    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return announcements?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AnnouncementTableViewCell
        cell.selectionStyle = .none
        // Configure the cell...
        
        if let announce = announcements {
        cell.date.text = announce[indexPath.row].dateString
        cell.quote.text = announce[indexPath.row].quote
        cell.author.text = announce[indexPath.row].author
        
        cell.bar.isHidden = true
        }
        return cell
    }
 }
