//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 06.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConversationsListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource  {

    @IBOutlet weak var ConversationListTableView: UITableView!
    
    var model : CommunicationListModelProtocol!
    
    var messages = ["online": [Message](), "history": [Message]()]
    
    required init?(coder aDecoder: NSCoder ) {
        
        super.init(coder: aDecoder)
    }
    
    static func initConversationsList(with model: CommunicationListModelProtocol) -> ConversationsListViewController {
        let conversationsListVC = UIStoryboard(name: "ConversationsList", bundle: nil).instantiateViewController(withIdentifier: "ConversationsListVC") as! ConversationsListViewController
        conversationsListVC.model = model
        return conversationsListVC
        
    }
 

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.fetchNewPeers()
    }
    
    @IBAction func profileButtonAction(_ sender: UIBarButtonItem) {
        
        let profileVC = ProfileAssembly().profileViewController()
        self.present(profileVC, animated: true, completion: nil)
        
    }
    
    // MARK - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
  
        let conversationVC = ConversationAssembly().conversationViewController()
        conversationVC.title = messages["online"]![indexPath.row].name
        conversationVC.userID = messages["online"]![indexPath.row].userID
        self.navigationController?.pushViewController(conversationVC, animated: true)
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

 // MARK: - CommunicationManagerDelegate

extension ConversationsListViewController: CommunicationManagerDelegate {
    
    func reloadData(with messages: [Message]) {
        self.messages["online"] = messages
        DispatchQueue.main.async {
            self.ConversationListTableView.reloadData()
        }
    }
}
