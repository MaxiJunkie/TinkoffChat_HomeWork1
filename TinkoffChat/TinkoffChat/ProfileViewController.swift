//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 20.09.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
         print("State is \(UIApplication.shared.nameOfState()) and method is \(#function)")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         print("State is \(UIApplication.shared.nameOfState()) and method is \(#function)")

  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        print("State is \(UIApplication.shared.nameOfState()) and method is \(#function)")

        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       
        print("State is \(UIApplication.shared.nameOfState()) and method is \(#function)")

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
         print("State is \(UIApplication.shared.nameOfState()) and method is \(#function)")

    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("State is \(UIApplication.shared.nameOfState()) and method is \(#function)")

        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
         print("State is \(UIApplication.shared.nameOfState()) and method is \(#function)")

    
    }

    
}

extension UIApplication {
    
    func nameOfState() -> String {
        
        switch UIApplication.shared.applicationState.rawValue {
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

