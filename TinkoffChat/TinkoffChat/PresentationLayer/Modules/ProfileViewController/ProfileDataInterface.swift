//
//  ProfileDataInterface.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 06.11.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation
import UIKit

class ProfileDataInterface {
    
    var name : String?
    var userInfo : String?
    var photoImage : UIImage?
    
    //isChanged
    
    var nameIsChanged = false
    var userInfoIsChanged = false
    var photoImageIsChanged = false
    
    init(with name: String?, userInfo: String?, image: UIImage? ) {
        self.name = name
        self.userInfo = userInfo
        self.photoImage = image
    }
    
}
