//
//  File.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 17.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

class RequestSender: IRequestSender {
    
    let session = URLSession.shared
    
    func send<Model>(config: RequestConfig<Model>, completionHandler: @escaping (Result<Model>) -> Void) {
        
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(Result.Fail("url string can't be parser to URL"))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completionHandler(Result.Fail(error.localizedDescription))
                return
            }
            guard let data = data,
                
                let parsedModel = config.parser.parse(data: data)  else {
                    completionHandler(Result.Fail("recieved data can't be parsed"))
                    return
            }
            
            completionHandler(Result.Success(parsedModel))
        }
        
        task.resume()
    }
}
