//
//  RequestsFactory.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 18.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

struct RequestsFactory {
    
    struct PixabayImagesRequests {
        
        static func imagesConfig() -> RequestConfig<[ImagesModel]> {
        
            return RequestConfig<[ImagesModel]>(request: PixabayImagesRequest(), parser: ImagesParser())
        }
    
    }
    
    struct PixabayImageRequests {
        
        static func imageConfig(with url: String) -> RequestConfig<ImageModel> {
            
            return RequestConfig<ImageModel>(request: PixabayImageRequest(with: url), parser: ImageParser())
        }
        
    }
    
    
}
