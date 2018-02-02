//
//  AppDelegate.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 05.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit
//import VK_ios_sdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        VKMAuthService.sharedInstance.process(url: url, options: options)
        return true
        
    }

}

