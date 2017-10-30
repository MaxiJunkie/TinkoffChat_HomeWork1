//
//  RootAssembly.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 28.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

class RootAssembly {
   var conversationsListModule: ConversationsListAssembly = ConversationsListAssembly()
    static let communicationManager: CommunicationManagerProtocol = CommunicationManager()
    
}
