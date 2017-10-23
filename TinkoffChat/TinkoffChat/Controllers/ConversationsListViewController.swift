//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 06.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConversationsListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var ConversationListTableView: UITableView!
    
    var communicationManager = CommunicationManager()
    
    var messages = ["online": [Message](), "history": [Message]()]
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        communicationManager.delegateOfConversations = self

       
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.ConversationListTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "showChat" {
            if let destination = segue.destination as? ConversationViewController {
             if  let messageCell = sender as? ConversationsTableViewCell {
                if let text = messageCell.nameOfUserLabel?.text {
                        destination.title = text
                        destination.communicationManager = communicationManager
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return messages["online"]!.count
        case 1:
            return messages["history"]!.count
        default:
            break
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let message: Message?
        if indexPath.section == 0 {
            message = messages["online"]![indexPath.row]
        } else {
            message = messages["history"]![indexPath.row]
        }
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

extension ConversationsListViewController: CommunicationManagerDelegate {
    func reloadData() {
        self.messages["online"] = communicationManager.onlinePeers
        DispatchQueue.main.async {
            self.ConversationListTableView.reloadData()
        }
    }
}
