//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 07.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController, UITableViewDelegate , UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var chatDialogTableView: UITableView!
    
    @IBOutlet weak var chatTextField: UITextField!
    
    var messagesArray: [Dictionary<String, String>] = []
    
    var conversationModel: ConversationModelProtocol!

    var userID : String?
 
    var conversationDataProvider: ConversationDataProvider<Messages>!
    
    
    static func initConversationVC(with model: ConversationModelProtocol) -> ConversationViewController {
        let conversationVC = UIStoryboard(name: "Conversation", bundle: nil).instantiateViewController(withIdentifier: "ConversationVC") as! ConversationViewController
        conversationVC.conversationModel = model
        return conversationVC
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        chatTextField.delegate = self
        self.chatDialogTableView.estimatedRowHeight = 140
        self.chatDialogTableView.rowHeight = UITableViewAutomaticDimension
        self.chatDialogTableView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
     
        conversationModel.userId = self.userID
       
        self.conversationDataProvider = ConversationDataProvider(tableView: chatDialogTableView, with: .Conversation)
        
        
        conversationModel.fetchedResultsController {[weak self] (frc) in
      
            self?.conversationDataProvider.fetchedResultsController = frc
            self?.conversationDataProvider.performFetch()
        
            self?.chatDialogTableView.reloadData()
            
        }
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    
    // MARK - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
     
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        guard let fetchedObjects = self.conversationDataProvider.fetchedResultsController?.fetchedObjects else { return 0 }
    
        return fetchedObjects.count
 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let frc = self.conversationDataProvider.fetchedResultsController else {
            return UITableViewCell()
        }
        
        let message = frc.object(at: indexPath)
     
        if  message.messageFromMe == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: "outboundCell")!
            if let messageCell = cell as? ChatTableViewCell {
                messageCell.selectionStyle = .none
                messageCell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                messageCell.textOfMessage = message.textOfMessage
            }
            return cell
        }
        else {
            let   cell = tableView.dequeueReusableCell(withIdentifier: "incomingCell")!
            if let messageCell = cell as? ChatTableViewCell {
                messageCell.selectionStyle = .none
                messageCell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                messageCell.textOfMessage = message.textOfMessage
            }
            return cell
        }
        
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        
        if let text = chatTextField.text, text != "" {
            if let userID = self.userID {
                conversationModel.sendMessage(text: text, toUserID: userID) {(success, error) in
                    if success {
                        DispatchQueue.main.async { [weak self] in
                            self?.chatTextField.text = ""
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
  
        return true
    }
    
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        if self.view.bounds.origin.y == 0   {
            adjustingHeight(show: true, notification: notification)
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        if self.view.bounds.origin.y > 0   {
            adjustingHeight(show: false, notification: notification)
        }
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = (keyboardFrame.height ) * (show ? 1 : -1)
        let view = self.view.bounds.origin.y
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.view.bounds.origin.y = view + changeInHeight
        })
    }
    
}



