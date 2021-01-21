//
//  AppDelegate.swift
//  Sitemaji_admob_mediation
//
//  Created by Alex on 2021/1/15.
//

import UIKit
import GoogleMobileAds
import VpadnSDKAdKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["88e7b8546ab9996522304d3feaf8f420"];
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // Vpon SDK initialization
        let config = VpadnAdConfiguration.sharedInstance()
        config.logLevel = .default
        config.initializeSdk()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

