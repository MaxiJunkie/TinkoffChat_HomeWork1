//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 07.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var chatDialogTableView: UITableView!
    
    var message = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.chatDialogTableView.rowHeight = UITableViewAutomaticDimension
        self.chatDialogTableView.estimatedRowHeight = 140
    
        message.append("1")
        var str : String = ""
        
        for _ in 0...29 {
            str = str + "1"
        }
         message.append(str)
        
        str = ""
        
        for _ in 0...299 {
            str = str + "1"
        }
        
        message.append(str)
        
    }

    
    
    // MARK - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        if indexPath.row < 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "outboundCell", for: indexPath)
             if let messageCell = cell as? ChatTableViewCell {
                messageCell.textOfMessage = message[indexPath.row]
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "incomingCell", for: indexPath)
            if let messageCell = cell as? ChatTableViewCell {
                messageCell.textOfMessage = message[indexPath.row - 3]
            }
             return cell
        }
        
       
    }
}
