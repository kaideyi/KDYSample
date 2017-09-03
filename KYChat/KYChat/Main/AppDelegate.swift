//
//  AppDelegate.swift
//  KYChat
//
//  Created by KYCoder on 2017/7/31.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainTabbarVC: KYTabBarController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        // 初始化EaseSDK
        setupEaseSDK(application, launchOptions: launchOptions)
        
        return true
    }
}

