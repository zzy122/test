//
//  AppDelegate.swift
//  ZZYTest
//
//  Created by my on 2022/10/27.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var appService: AppService?
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let appWindow = UIWindow(frame: UIScreen.main.bounds)
        window = appWindow
        
        appService = AppService(window: appWindow, options: launchOptions)
        return true
    }
}

