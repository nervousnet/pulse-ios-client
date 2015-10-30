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
    let sharedDefaults = NSUserDefaults(suiteName: "group.ch.ethz.coss.nervous")
    var window: UIWindow?
    let VM = PulseVM.sharedInstance
    
    
        
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(1)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        NSLog("shoulddie")
//        _ = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1), target: self, selector: Selector("sendPendingMessages"), userInfo: nil, repeats: true)
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        self.sendPendingMessages()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
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
    
    func fetch(completion: () -> Void) {
        completion()
        
    }
    
    func continuousMessageScan(interval : Int){
        _ = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(interval), target: self, selector: Selector("sendPendingMessages"), userInfo: nil, repeats: true)
    }
    
    func sendPendingMessages (){
        if (sharedDefaults?.boolForKey("hasBeenPushed") == nil){
            sharedDefaults?.setBool(true, forKey: "hasBeenPushed")
        }
       
        if (sharedDefaults?.boolForKey("hasBeenPushed") == false){
            let sharedText = sharedDefaults?.objectForKey("stringKey") as? String
            VM.textCollection(sharedText!)
            sharedDefaults?.setBool(true, forKey: "hasBeenPushed")
            sharedDefaults?.synchronize()
            NSLog(sharedDefaults?.objectForKey("stringKey") as! String!)
            
        }
        NSLog("Still alive")
    }
    
    func sendPendingMessages (completionHandler: (UIBackgroundFetchResult) -> Void){
        if (sharedDefaults?.boolForKey("hasBeenPushed") == nil){
            sharedDefaults?.setBool(true, forKey: "hasBeenPushed")
        }
        if (sharedDefaults?.boolForKey("hasBeenPushed") == false){
            let sharedText = sharedDefaults?.objectForKey("stringKey") as? String
            VM.textCollection(sharedText!)
            sharedDefaults?.setBool(true, forKey: "hasBeenPushed")
            sharedDefaults?.synchronize()
            NSLog(sharedDefaults?.objectForKey("stringKey") as! String!)
//            completionHandler(.NewData)
 
        }
        NSLog("Still alive")
    }

}

