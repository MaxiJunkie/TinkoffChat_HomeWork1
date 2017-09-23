//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 20.09.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var oldStateOfApplicationValue: Int = UIApplication.shared.applicationState.rawValue
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print ("Application moved from start to \(nameOfState(withValue: application.applicationState.rawValue)) state: \(#function)" )
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
   
        print ("Application moved from \(nameOfState(withValue: oldStateOfApplicationValue)) to \(nameOfState(withValue: application.applicationState.rawValue)) state: \(#function)" )
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
     
        print ("Application moved from \(nameOfState(withValue: oldStateOfApplicationValue)) to \(nameOfState(withValue: application.applicationState.rawValue)) state: \(#function)" )
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
     
        print ("Application moved from \(nameOfState(withValue: oldStateOfApplicationValue)) to \(nameOfState(withValue: application.applicationState.rawValue)) state: \(#function)" )
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        print ("Application moved from \(nameOfState(withValue: oldStateOfApplicationValue)) to \(nameOfState(withValue: application.applicationState.rawValue)) state: \(#function)" )
    }

    func applicationWillTerminate(_ application: UIApplication) {
      
        print ("Application moved from \(nameOfState(withValue: oldStateOfApplicationValue)) to suspended state: \(#function)" )
    }
  
    
    func nameOfState(withValue value:Int) -> String {
        
        if value != oldStateOfApplicationValue {
           
            oldStateOfApplicationValue = value
        
        }
      
        switch value {
        case 0:
            return "active"
        case 1:
            return "inactive"
        case 2:
            return "background"
        default: break
        }
        return ""
    }
    
}



