//
//  AppDelegate.swift
//  SwarmPulse
//
//  Created by Lewin Könemann on 22/10/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let sharedDefaults = UserDefaults(suiteName: "group.ch.ethz.coss.nervous")
    var window: UIWindow?
    let VM = PulseVM.sharedInstance
    
    
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.setMinimumBackgroundFetchInterval(1)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        NSLog("shoulddie")
//        _ = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1), target: self, selector: Selector("sendPendingMessages"), userInfo: nil, repeats: true)
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        self.sendPendingMessages()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
//    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
//        NSLog("background")
//        self.sendPendingMessages(completionHandler)
//        sharedDefaults?.setBool(true, forKey: "hasBeenPushed")
//
////            let homeTableViewController = self.window?.rootViewController as! HomeTableViewController
////            homeTableViewController.fetch(homeTableViewController.sendPendingMessages())
//        
//    }
    
    func fetch(_ completion: () -> Void) {
        completion()
        
    }
    
    func continuousMessageScan(_ interval : Int){
        _ = Timer.scheduledTimer(timeInterval: TimeInterval(interval), target: self, selector: Selector("sendPendingMessages"), userInfo: nil, repeats: true)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let urlScheme = url.scheme //[URL_scheme]
        let host = url.host //red
        print("HelloHelloHello" + host!)
        return true
    }
    
    
//    func sendPendingMessages (){
//        if (sharedDefaults?.boolForKey("hasBeenPushed") == nil){
//            sharedDefaults?.setBool(true, forKey: "hasBeenPushed")
//        }
//       
//        if (sharedDefaults?.boolForKey("hasBeenPushed") == false){
//            let sharedText = sharedDefaults?.objectForKey("stringKey") as? String
//            VM.textCollection(sharedText!)
//            sharedDefaults?.setBool(true, forKey: "hasBeenPushed")
//            sharedDefaults?.synchronize()
//            NSLog(sharedDefaults?.objectForKey("stringKey") as! String!)
//            
//        }
//        NSLog("Still alive")
//    }
    func sendPendingMessages (){
        let sharedDefaults = UserDefaults(suiteName: "group.ch.ethz.coss.nervous")
        
        if let _ = sharedDefaults?.bool(forKey: "hasBeenPushed") {
            if (sharedDefaults?.bool(forKey: "hasBeenPushed") == false){
                if let sharedText = sharedDefaults?.object(forKey: "stringKey") as? String{
                    VM.textCollection(sharedText)
                    sharedDefaults?.set(true, forKey: "hasBeenPushed")
                    sharedDefaults?.synchronize()
                    NSLog(sharedDefaults?.object(forKey: "stringKey") as! String!)
                }
            }
        }
        //NSLog(sharedDefaults?.objectForKey("stringKey") as! String!)
    }
    func sendPendingMessages (_ completionHandler: (UIBackgroundFetchResult) -> Void){
        if (sharedDefaults?.bool(forKey: "hasBeenPushed") == nil){
            sharedDefaults?.set(true, forKey: "hasBeenPushed")
        }
        if (sharedDefaults?.bool(forKey: "hasBeenPushed") == false){
            let sharedText = sharedDefaults?.object(forKey: "stringKey") as? String
            VM.textCollection(sharedText!)
            sharedDefaults?.set(true, forKey: "hasBeenPushed")
            sharedDefaults?.synchronize()
            NSLog(sharedDefaults?.object(forKey: "stringKey") as! String!)
//            completionHandler(.NewData)
 
        }
        NSLog("Still alive")
    }

}

