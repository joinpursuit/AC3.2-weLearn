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
        
        
        if let linkDescription = self.textView.text,
            let url = self.urlString {
            
            let dict = [ "url" : url,
                "urlDescription" : linkDescription
            ]
            
            let userDefaults = UserDefaults(suiteName: "group.com.welearn.app")

            if var urlDefaults = userDefaults?.object(forKey: "urlDefaults") as? [[String : String]] {
                urlDefaults.append(dict)
                userDefaults?.synchronize()
            } else {
                userDefaults?.setValue([dict], forKey: "urlDefaults")
                userDefaults?.synchronize()
            }   
        }
        
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
