//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 20.09.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let rootAssembly = RootAssembly()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let controller = rootAssembly.conversationsListModule.conversationsListViewController()
        let navVC = UINavigationController.init(rootViewController: controller)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
   
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
  
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
     
     
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
  
    }

    func applicationWillTerminate(_ application: UIApplication) {
      
   
    }
    
}



