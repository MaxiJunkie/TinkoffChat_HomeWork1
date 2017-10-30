//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 07.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate , UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var chatDialogTableView: UITableView!
    
    @IBOutlet weak var chatTextField: UITextField!
    
    var messagesArray: [Dictionary<String, String>] = []
    
    var conversationModel: ConversationModelProtocol!

    var userID : String?
    
    
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
        conversationModel.fetchNewMessages()
 
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
       
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let currentMessage = messagesArray[messagesArray.count - 1] as Dictionary<String, String>
        
        var sender : String = ""
        
        if let sen  = currentMessage["sender"] {
            sender = sen
        }
        
        if  sender == "self" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "incomingCell")!
            if let messageCell = cell as? ChatTableViewCell {
                if let message = currentMessage["message"] {
                    messageCell.textOfMessage = message
                    messageCell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                }
            }
            return cell
        }
        else {
          let   cell = tableView.dequeueReusableCell(withIdentifier: "outboundCell")!
            if let messageCell = cell as? ChatTableViewCell {
                if let message = currentMessage["message"] {
                    messageCell.textOfMessage = message
                    messageCell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                    }
                }
            return cell
        }
    }
    
    // MARK - UITextFieldDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        if let text = textField.text {
            if let userID = self.userID {
            conversationModel.sendMessage(text: text, toUserID: userID) {(success, error) in
                if success {
                        let messageDictionary: [String: String] = ["sender": "self", "message": text]
                        self.messagesArray.append(messageDictionary)
                        DispatchQueue.main.async { [weak self] in
                            self?.updateTableview()
                            textField.text = ""
                        }
                    }
                }
            }
        }
        
        return true
    }
    
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    
    func updateTableview(){
        
        self.chatDialogTableView.beginUpdates()
        let indexPaths = [IndexPath(row: 0, section: 0),]
        self.chatDialogTableView.insertRows(at: indexPaths, with: .top)
        self.chatDialogTableView.endUpdates()
 
        if self.chatDialogTableView.contentSize.height > self.chatDialogTableView.frame.size.height {
            
            chatDialogTableView.scrollToRow(at: IndexPath.init(row: messagesArray.count - 1, section: 0), at: .top, animated: true)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.chatDialogTableView.endEditing(true)
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

extension ConversationViewController: CommunicationManagerDelegate {
   
    func reloadData(with messages: [Message]) {
      
        for user in messages {
            if user.userID == self.userID {
                if let lastMessage =  user.messages?.last {
                    let messageDictionary: [String: String] = ["sender": "not", "message": lastMessage]
                    messagesArray.append(messageDictionary)
                    DispatchQueue.main.async { [weak self] in
                        self?.updateTableview()
                    }
                    break
                }
            }
        }
    }
}

