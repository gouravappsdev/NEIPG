//
//  PGAppDelegate.swift
//  NEIPG
//
//  Created by Gourav Sharma on 11/18/16.
//  Copyright © 2016 Yaogeng Cheng. All rights reserved.
//

import UIKit


@UIApplicationMain

class PGAppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //UINavigationBar.appearance().barTintColor = UIColor.navigationBarTintBackgroundColor()
        UIToolbar.appearance().barTintColor = UIColor.toolBarTintBackgroundColor()
        self.createDynamicShortcutItems()
        return true
    }
    
    
    func createDynamicShortcutItems()
    {
        if #available(iOS 9.0, *) {
            
            var items = [UIApplicationShortcutItem]()
            let photoIcon = UIApplicationShortcutIcon(templateImageName: applicationShortCutIcon)
            
            let defaults = UserDefaults.standard
            

            if let checkSiteItem1 =  defaults.object(forKey: "NEISHORTCUTITEMS1")
            {
                let item1 = UIApplicationShortcutItem(type: "NEIAPPSHORTCUT2", localizedTitle: checkSiteItem1 as! String, localizedSubtitle: nil, icon: photoIcon, userInfo: nil)
                items.append(item1)
            }
            
            if let checkSiteItem2 =  defaults.object(forKey: "NEISHORTCUTITEMS2")
            {
                let item2 = UIApplicationShortcutItem(type: "NEIAPPSHORTCUT3", localizedTitle: checkSiteItem2 as! String, localizedSubtitle: nil, icon: photoIcon, userInfo: nil)
                items.append(item2)
            }
            
            if let checkSiteItem1 =  defaults.object(forKey: "NEISHORTCUTITEMS3")
            {
                let item3 = UIApplicationShortcutItem(type: "NEIAPPSHORTCUT4", localizedTitle: checkSiteItem1 as! String, localizedSubtitle: nil, icon: photoIcon, userInfo: nil)
                items.append(item3)
            }
            
            if items.count > 0 {
                // add this array to the potentially existing static UIApplicationShortcutItems
                UIApplication.shared.shortcutItems = items
            }
        }
    }
    
    
    @available(iOS 9.0, *)
    private func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        
        let vc = (self.window!.rootViewController! as! InitViewController)
        vc.shortCutItem = shortcutItem.localizedTitle
        
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        self.createDynamicShortcutItems()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        let defaults = UserDefaults.standard
        
        if defaults.integer(forKey:applicationLaunchCount) > 0
        {
             defaults.set(defaults.integer(forKey:applicationLaunchCount) + 1, forKey: applicationLaunchCount)
            
        } else {
            
             defaults.set(1, forKey: applicationLaunchCount)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
         }
}

