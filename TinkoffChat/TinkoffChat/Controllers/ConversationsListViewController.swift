//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 06.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var ConversationListTableView: UITableView!
    
    var messages = [[Message]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var onlineMessages = [Message]()
        var historyMessages = [Message]()
        for message in Message.messages {
          
            if message.online {
                onlineMessages.append(message)
            }
            else {
                historyMessages.append(message)
            }
       
        }
        messages.append(onlineMessages)
        messages.append(historyMessages)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChat" {
            if let destination = segue.destination as? ConversationViewController {
             if  let messageCell = sender as? ConversationsTableViewCell {
                if let text = messageCell.nameOfUserLabel?.text {
                        destination.title = text
                    }
                }
            }
        }
    }
    
    // MARK - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return messages[0].count
        case 1:
            return messages[1].count
        default:
            break
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let message: Message = messages[indexPath.section][indexPath.row]
        if let messageCell = cell as? ConversationsTableViewCell {
            messageCell.messageOfHistory = message
        }
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        case 1:
            return "History"
        default:
            break
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }

}
