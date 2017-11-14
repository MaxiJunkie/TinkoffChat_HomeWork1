//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 06.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreData

class ConversationsListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource  {

    @IBOutlet weak var ConversationListTableView: UITableView!
    
    var model : CommunicationListModelProtocol!
    
  
    var conversationDataProvider: ConversationDataProvider!
    
    required init?(coder aDecoder: NSCoder ) {
        super.init(coder: aDecoder)
    }
    
    static func initConversationsList(with model: CommunicationListModelProtocol) -> ConversationsListViewController {
        let conversationsListVC = UIStoryboard(name: "ConversationsList", bundle: nil).instantiateViewController(withIdentifier: "ConversationsListVC") as! ConversationsListViewController
        conversationsListVC.model = model
        return conversationsListVC
        
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.conversationDataProvider = ConversationDataProvider(tableView: ConversationListTableView)
        
        self.model.fetchedResultsController(completion: { [weak self] (frc) in
            
            self?.conversationDataProvider.fetchedResultsControllerUser = frc
            self?.conversationDataProvider.performFetch()
            self?.ConversationListTableView.reloadData()
            
        })
    
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        model.fetchNewPeers {
            self.ConversationListTableView.reloadData()
        }
    }

  
    @IBAction func profileButtonAction(_ sender: UIBarButtonItem) {
        
        let profileVC = ProfileAssembly().profileViewController()
        self.present(profileVC, animated: true, completion: nil)
        
    }
    
    // MARK - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
  
        let conversationVC = ConversationAssembly().conversationViewController()
        if let user = self.conversationDataProvider.fetchedResultsControllerUser?.object(at: indexPath) {
            conversationVC.title = user.name
            conversationVC.userID = user.userId
            self.navigationController?.pushViewController(conversationVC, animated: true)
        }
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
      
        guard let frc = self.conversationDataProvider.fetchedResultsControllerUser, let sectionsCount =
            frc.sections?.count else {
                return 0 }
        return sectionsCount
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let frc = self.conversationDataProvider.fetchedResultsControllerUser, let sections = frc.sections else {
            return 0 }
        return sections[section].numberOfObjects
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
   
        if let user = self.conversationDataProvider.fetchedResultsControllerUser?.object(at: indexPath) {
            if let messageCell = cell as? ConversationsTableViewCell {
               
                messageCell.configuarateMessage = user
            }
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




