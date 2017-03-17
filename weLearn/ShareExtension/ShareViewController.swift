//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Cris on 3/7/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//
import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    private var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.placeholder = "Type a description of the Link"
        
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        
        let propertyList = String(kUTTypeURL)
        
        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { (item, error) -> Void in
                
                guard let url = item else { return }
                let urlString = String(describing: url)
                self.urlString = urlString
                
            })
        } else {
            print("error")
        }
        
        let image = UIImage(named: "weLearnCloudWhite.png")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
        
        navigationController?.navigationBar.topItem?.titleView = imageView
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = UIColor(red:0.46, green:0.75, blue:0.75, alpha:1.0)
        
    }
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        
        guard let userUID = getUserIDFromUserDefaults() else { return }
        getStudentClassFromDatabase(studentID: userUID) { (studentDict) -> (Void) in
            guard let studentClassKey = studentDict["classKey"] as? String,
            let studentClass = studentDict["class"] as? String,
                let studentName = studentDict["studentName"] as? String else { return }
            if let linkDescription = self.textView.text,
                let url = self.urlString {
                let uniqueID = String(Int(Date.timeIntervalSinceReferenceDate * 1000))
                
                let urlString = "https://welearn-a2b14.firebaseio.com/links/\(studentClassKey)/\(uniqueID).json"
                
                let now = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yy'T'HH:mmZZZZZ"
                let dateString = dateFormatter.string(from: now)
                
                guard let validURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let validURL = URL(string: validURLString) else { return }
                var request = URLRequest(url: validURL)
                let session = URLSession(configuration: .default)
                request.httpMethod = "PUT"
                
                let dict = [ "url" : url,
                             "urlDescription" : linkDescription,
                             "studentClass" : studentClass,
                             "studentName" : studentName,
                             "date" : dateString,
                             "studentKey" : userUID
                ]
                
                do {
                    let json = try JSONSerialization.data(withJSONObject: dict, options: [])
                    request.httpBody = json
                }
                catch {
                    print("error turning dict to json")
                }
                
                session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                    if let data = data {
                        print(data)
                    }
                    if let response = response {
                        print(response)
                    }
                    if let error = error {
                        print(error)
                    }
                }).resume()
                
            }
            
        }
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    func getUserIDFromUserDefaults() -> String? {
        guard let userDefaults = UserDefaults(suiteName: "group.com.welearn.app"),
            let userUID = userDefaults.object(forKey: "studentInfo") as? String else { return nil }
        return userUID
    }
    
    func getStudentClassFromDatabase(studentID: String, _ completionHandler: @escaping ([String : Any])->(Void)) {
        let urlString = "https://welearn-a2b14.firebaseio.com/users/\(studentID).json"
        guard let validURL = URL(string: urlString) else { return }
        var request = URLRequest(url: validURL)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let data = data {
                print(data)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dict = json as? [String : Any] {
                        completionHandler(dict)
                    }
                }
                catch {
                    print("error")
                }
            }
            if let response = response {
                print(response)
            }
            if let error = error {
                print(error)
            }
            }.resume()
    }
    
    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
}
