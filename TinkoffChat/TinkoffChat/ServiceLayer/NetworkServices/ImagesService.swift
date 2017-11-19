//
//  ImagesService.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 18.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

protocol IImagesService {
    func loadNewImages(completionHandler: @escaping (ImagesModel?, String?) -> Void)
}


class ImagesService: IImagesService {
    
    let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func loadNewImages(completionHandler: @escaping (ImagesModel?, String?) -> Void) {
      
        let requestConfig: RequestConfig<ImagesModel> = RequestsFactory.PixabayImagesRequests.imagesConfig()
        
        loadImages(requestConfig: requestConfig, completionHandler: completionHandler)
    }

    private func loadImages(requestConfig: RequestConfig<ImagesModel>,
                          completionHandler: @escaping (ImagesModel?, String?) -> Void) {
        requestSender.send(config: requestConfig) { (result: Result<ImagesModel>) in
            
            switch result {
            case .Success(let images):
                completionHandler(images, nil)
            case .Fail(let error):
                completionHandler(nil, error)
            }
        }
    }
    
}
