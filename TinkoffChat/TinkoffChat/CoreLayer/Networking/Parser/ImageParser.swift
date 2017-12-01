//
//  ImageParser.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 23.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation
import UIKit

struct ImageModel  {
    
    let image: UIImage
    
}

class ImageParser: Parser<ImageModel> {
    
    override func parse(data: Data) -> ImageModel? {
        if let image = UIImage(data: data) {
          return ImageModel.init(image: image)
        }
        return nil
    }
    
}
