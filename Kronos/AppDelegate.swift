
//
//  AppDelegate.swift
//  Kronos
//
//  Created by Wee, David G. on 8/15/16.
//  Copyright © 2016 davidwee. All rights reserved.
//

import Foundation
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: Any]?) -> Bool {
        // Override point for customization after application launch.

        //Invoice.deleteAll()
        //createFolder(name: "Invoices")
        
        if UserDefaults.standard.value(forKey: FIRST_LAUNCH) == nil
       {
            ChronoUserDefaults.setupFistTimeValues()
            copyIntoDocuments(fileName: "Invoices")
            createFolder(name: "Invoices")
            let date = Date()
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            UserDefaults.standard.setValue(year, forKey: "USER_DOWNLOAD_YEAR")
            UserDefaults.standard.setValue(0, forKey: "download_count")
        }
        initWindow()
        let _ = DataController.sharedInstance
        if let window = window {
            
            let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
            if launchedBefore {
                HomeWireframe.addHomeControllerOnWindow(window)
            } else {
                HomeWireframe.addIntroScreenOnWindow(window)
                UserDefaults.standard.set(true, forKey: "launchedBefore")
            }
        }
        window?.makeKeyAndVisible()

        return true
    }
    
    fileprivate func initWindow() {
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
    }

   
    func prefersStatusBarHidden() -> Bool {
        return false
    }

    func copyIntoDocuments(fileName:String)
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]   as String
        let path = paths.appending("/\(fileName).plist")
        let fileManager = FileManager.default
        if (!(fileManager.fileExists(atPath: path)))
        {
            let bundle = Bundle.main.path(forResource: fileName, ofType: "plist")
            do{
                try fileManager.copyItem(atPath: bundle!, toPath: path)
            }catch{
                print("failed")
            }
        }

    }
    
    func createFolder(name:String)
    {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dataPath = paths.appending("/\(name)")
        do {
            try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        ChronoTimer.sharedInstance.appWillClose()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "didBecomeActive")))
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        ChronoTimer.sharedInstance.appWillClose()
    }


    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let data = try! Data(contentsOf: url)
        let dict = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)

        KronoBackupCreator.importData(dict as! NSArray)
        var value = UserDefaults.standard.value(forKey: "download_count") as! Int
        value += 1
        UserDefaults.standard.setValue(value, forKey: "download_count")


        return true
    }
    

}

