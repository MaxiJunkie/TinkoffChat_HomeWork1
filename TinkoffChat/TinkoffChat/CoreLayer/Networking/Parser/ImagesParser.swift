//
//  ImagesParser.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 18.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

struct ImagesModel  {

    let imageUrl: String
    
}


class ImagesParser: Parser<[ImagesModel]> {
    
    override func parse(data: Data) -> [ImagesModel]? {
       
        do {
            
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                return nil
            }
            
        
            guard let hits = json["hits"] as? [Any] else { return nil }
          
            var images: [ImagesModel] = []
            
            for object in hits {
                if let dictionary = object as? [String:Any] {
                    if let webformatURL = dictionary["webformatURL"] as? String {
                        let imageModel = ImagesModel.init(imageUrl: webformatURL)
                        images.append(imageModel)
                    }
                }
            }
   
            return images
            
        } catch  {
            print("error trying to convert data to JSON")
            return nil
        }
 
 
    }
    
}
