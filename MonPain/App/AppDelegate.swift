//
//  AppDelegate.swift
//  MonPain
//
//  Created by Jonathan Duss on 31.05.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit

#if LITE
import Firebase
import GoogleMobileAds
import UserMessagingPlatform
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        #if LITE
            // Configuring Firebase and Google Admob
            FirebaseApp.configure()
            GADMobileAds.sharedInstance().start(completionHandler: nil)
            #if DEBUG
                GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [kGADSimulatorID as! String, "1d2fa156ca8b7ebdad77f923ee6eb4e2", "55291B81-34D0-493E-8F3A-B43E3360FB55"]
            #endif
        #endif
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
