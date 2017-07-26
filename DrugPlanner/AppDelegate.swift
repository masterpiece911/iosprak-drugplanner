//
//  AppDelegate.swift
//  DrugPlanner
//
//  Created by Elena Karypidou on 24.05.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
////
////

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var ref : DatabaseReference!
    
    var mainRepository : Repository!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = false;
        ref = Database.database().reference()

        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: LoginStrings.USER_LOGGED_IN), object:nil, queue:nil) {
            notification in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainController = storyboard.instantiateViewController(withIdentifier: "Main") as UIViewController
            self.window?.rootViewController = mainController
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: LoginStrings.LOGOUT_SUCCESS), object: nil, queue: nil) {
            notification in
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let loginController = storyboard.instantiateViewController(withIdentifier: "Login") as UIViewController
            self.window?.rootViewController = loginController
        }
        
        mainRepository = Repository(referencing: ref)
        
        registerForPushNotifications()
        
        UserNotifications.instance.setUp()
                
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
        
    func registerForPushNotifications () {
        UNUserNotificationCenter.current().requestAuthorization (options: [.alert, .sound, .badge]) {
            (granted, error) in
//            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings () {
        UNUserNotificationCenter.current().getNotificationSettings{
            (settings) in
//            print ("Notification Settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }


}

