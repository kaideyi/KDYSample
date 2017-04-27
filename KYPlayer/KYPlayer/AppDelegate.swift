//
//  AppDelegate.swift
//  KYPlayer
//
//  Created by mac on 17/4/11.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        
        let navigation = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        
        return true
    }
}

