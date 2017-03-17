//
//  AppDelegate.swift
//  weLearn
//
//  Created by Victor Zhong on 2/27/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//
import UIKit
import SnapKit
import Firebase
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var bigCloudView: UIImageView?
    var leftCloudView1: UIImageView?
    var leftCloudView2: UIImageView?
    var leftCloudView3: UIImageView?
    var rightCloudView1: UIImageView?
    var rightCloudView2: UIImageView?
    var rightCloudView3: UIImageView?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Firebase config
        FIRApp.configure()
        classSheetsSetup()
        //UIApplication.shared.statusBarStyle = .lightContent
        StyleManager.styler.prettify()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window = self.window {
            window.backgroundColor =  UIColor.weLearnBlue
            
            let myRootVC = InitialViewController()
            window.rootViewController = myRootVC
            window.makeKeyAndVisible()
            
            self.bigCloudView = UIImageView()
            self.leftCloudView1 = UIImageView()
            self.leftCloudView2 = UIImageView()
            self.leftCloudView3 = UIImageView()
            self.rightCloudView1 = UIImageView()
            self.rightCloudView2 = UIImageView()
            self.rightCloudView3 = UIImageView()
            
            self.bigCloudView?.contentMode = .center
            self.bigCloudView?.image = #imageLiteral(resourceName: "logoForSplash")
            self.bigCloudView?.alpha = 1
            
            self.leftCloudView1?.contentMode = .center
            self.leftCloudView2?.contentMode = .center
            self.leftCloudView3?.contentMode = .center
            self.leftCloudView1?.image = #imageLiteral(resourceName: "logoForHeader")
            self.leftCloudView2?.image = #imageLiteral(resourceName: "logoForHeader")
            self.leftCloudView3?.image = #imageLiteral(resourceName: "logoForHeader")
            
            self.rightCloudView1?.contentMode = .center
            self.rightCloudView2?.contentMode = .center
            self.rightCloudView3?.contentMode = .center
            self.rightCloudView1?.image = #imageLiteral(resourceName: "logoForHeader")
            self.rightCloudView2?.image = #imageLiteral(resourceName: "logoForHeader")
            self.rightCloudView3?.image = #imageLiteral(resourceName: "logoForHeader")
            
            self.leftCloudView1?.alpha = 0.8
            self.leftCloudView2?.alpha = 0.8
            self.leftCloudView3?.alpha = 0.8
            self.rightCloudView1?.alpha = 0.8
            self.rightCloudView2?.alpha = 0.8
            self.rightCloudView3?.alpha = 0.8
            
            self.window?.addSubview(self.bigCloudView!)
            self.window?.addSubview(leftCloudView1!)
            self.window?.addSubview(leftCloudView2!)
            self.window?.addSubview(leftCloudView3!)
            self.window?.addSubview(rightCloudView1!)
            self.window?.addSubview(rightCloudView2!)
            self.window?.addSubview(rightCloudView3!)
            
            self.bigCloudView?.snp.makeConstraints { view in
                view.center.equalToSuperview()
                view.width.equalToSuperview()
                view.height.equalToSuperview()
            }
            
            self.leftCloudView1?.snp.makeConstraints { view in
                view.leading.equalToSuperview()
                view.centerY.equalTo(window.snp.bottom).inset(20)
            }
            
            self.leftCloudView2?.snp.makeConstraints { view in
                view.leading.equalTo((leftCloudView1?.snp.trailing)!).inset(50)
                view.centerY.equalTo(window.snp.bottom).inset(20)
            }
            
            self.leftCloudView3?.snp.makeConstraints { view in
                view.centerX.equalTo((leftCloudView1?.snp.trailing)!)
                view.centerY.equalTo((leftCloudView1?.snp.top)!)
            }
            
            self.rightCloudView1?.snp.makeConstraints { view in
                view.trailing.equalTo(window.snp.trailing)
                view.centerY.equalTo(window.snp.bottom).inset(20)
            }
            
            self.rightCloudView2?.snp.makeConstraints { view in
                view.trailing.equalTo((rightCloudView1?.snp.leading)!).offset(50)
                view.centerY.equalTo(window.snp.bottom).inset(20)
            }
            
            self.rightCloudView3?.snp.makeConstraints { view in
                view.centerX.equalTo((rightCloudView1?.snp.leading)!)
                view.centerY.equalTo((rightCloudView1?.snp.top)!)
            }
            
            UIView.animate(withDuration: 2, animations: {
                self.bigCloudView?.alpha = 0
                self.bigCloudView?.transform = CGAffineTransform(scaleX: 3, y: 3)
                self.leftCloudView1?.transform = CGAffineTransform(translationX: -600, y: 0)
                self.rightCloudView1?.transform = CGAffineTransform(translationX: 600, y: 0)
                self.leftCloudView2?.transform = CGAffineTransform(translationX: -600, y: 0)
                self.rightCloudView2?.transform = CGAffineTransform(translationX: 600, y: 0)
                self.leftCloudView3?.transform = CGAffineTransform(translationX: -600, y: -300)
                self.rightCloudView3?.transform = CGAffineTransform(translationX: 600, y: -300)
            }, completion: { finish in
                self.bigCloudView?.removeFromSuperview()
                self.leftCloudView1?.removeFromSuperview()
                self.leftCloudView2?.removeFromSuperview()
                self.leftCloudView3?.removeFromSuperview()
                self.rightCloudView1?.removeFromSuperview()
                self.rightCloudView2?.removeFromSuperview()
                self.rightCloudView3?.removeFromSuperview()
            })
        }
        
        classSheetsSetup()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        let studentInfoUserDefaults = UserDefaults.standard
        guard let studentInfo = studentInfoUserDefaults.object(forKey: "studentInfo") as? [String : String],
            let studentClass = studentInfo["class"],
            let studentName = studentInfo["studentName"] else { return }
        
        //        let databaseReference = FIRDatabase.database().reference().child("Links").child(studentClass).childByAutoId()
        //
        //        let userDefaults = UserDefaults(suiteName: "group.com.welearn.app")
        //
        //        if let urlDefaults = userDefaults?.object(forKey: "urlDefaults") as? [[String : String]] {
        //            for urlDict in urlDefaults {
        //                let databaseReference = FIRDatabase.database().reference().child("Links").child(studentClass).childByAutoId()
        //                var urlInfo = urlDict
        //                urlInfo["studentName"] = studentName
        //                databaseReference.setValue(urlInfo)
        //            }
        //
        //        }
        
        
        //        userDefaults?.removeObject(forKey: "urlDefaults")
        
        
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        print("did enter the function")
    }
    
    func classSheetsSetup() {
        APIRequestManager.manager.getData(endPoint: "https://spreadsheets.google.com/feeds/list/1bY09jvCzHdfTLHMcsgKoGIDZnHwYzIzrnTnwgJU7UNU/od6/public/basic?alt=json") { (data: Data?) in
            
            
            if data != nil {
                if let returnedClasses = ClassFromSheet.getClasses(from: data!) {
                    print("We've got returns: \(returnedClasses.count)")
                    DispatchQueue.main.async {
                        ClassFromSheet.postClassInfoToDatabase(returnedClasses)
                        // Start the code
                    }
                }
            }
        }
    }
    
}
