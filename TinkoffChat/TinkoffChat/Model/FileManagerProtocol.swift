//
//  FileManagerProtocol.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 15.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

protocol FileManagerProtocol : class {
    func createdFile(_ url: URL?) -> Bool
    func readDataFromFile(completion: @escaping (([String: Any]) -> ()), errorBlock: ((NSError) -> ())?)
    func writeDataInFile(_ dictionary : [String: Any], completion: (() -> ())?, errorBlock: ((NSError) -> ())?)
}
