//
//  ImagesParser.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 18.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

struct ImagesModel: IModel  {

    typealias Model = ImagesParser
    let imagesWithUrl: [String]
    
}


class ImagesParser: Parser<ImagesModel> {
    
    override func parse(data: Data) -> ImagesModel? {
       
        do {
            
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                return nil
            }
            
        
            guard let hits = json["hits"] as? [Any] else { return nil }
          
            var images: [String] = []
            
            for object in hits {
                if let dictionary = object as? [String:Any] {
                    if let webformatURL = dictionary["webformatURL"] as? String {
                        images.append(webformatURL)
                    }
                }
            }
        
            let imageModel = ImagesModel.init(imagesWithUrl: images)
    
            return imageModel
            
        } catch  {
            print("error trying to convert data to JSON")
            return nil
        }
 
 
    }
    
}
