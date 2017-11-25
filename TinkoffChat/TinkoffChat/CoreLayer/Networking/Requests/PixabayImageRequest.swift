//
//  PixabayImageRequest.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 23.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation


class PixabayImageRequest : IRequest {
    
    let url: String?
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        guard let urlString = self.url else {return nil}
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
    
    // MARK: - Initialization
    
    init(with url: String ) {
        self.url = url
    }
    
}


