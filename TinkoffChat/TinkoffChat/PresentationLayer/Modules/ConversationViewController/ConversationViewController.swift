//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 07.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: AnimationViewController, UITableViewDelegate , UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var chatDialogTableView: UITableView!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTextField: UITextField!
    
    var messagesArray: [Dictionary<String, String>] = []
    var conversationModel: ConversationModelProtocol!
    let animator = ConversationAnimator()
    
    
    var sendButtonIsActive: Bool = false {
        didSet {
            self.sendButton.isEnabled = sendButtonIsActive
            animator.showAnimationIfUser(isOnline: sendButtonIsActive, for: self.sendButton)
        }
    }
    
    var userID : String?
    
    var userIsOnline: Bool = true
    
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
        self.chatTextField.addTarget(self, action: #selector(ConversationViewController.textFieldDidChange(_:)), for: .editingChanged)
        chatTextField.delegate = self
        self.chatDialogTableView.estimatedRowHeight = 140
        self.chatDialogTableView.rowHeight = UITableViewAutomaticDimension
        self.chatDialogTableView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        conversationModel.userId = self.userID
        self.sendButton.backgroundColor = UIColor.red
     
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        titleLabel.textColor = userIsOnline ? UIColor.green : UIColor.black
        titleLabel.text = self.title
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
      
        conversationModel.updateCurrentUser { (userId, userName, isOnline) in
            
            self.userIsOnline = isOnline
   
            if isOnline == true {
                if self.sendButtonIsActive == false, self.chatTextField.text != "" {
                    self.sendButtonIsActive = true
                }
                self.animator.showAnimationIfUser(isOnline: true, for: titleLabel)
            } else {
                if self.sendButtonIsActive == true {
                    self.sendButtonIsActive = false
                }
                self.animator.showAnimationIfUser(isOnline: false, for: titleLabel)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        self.conversationDataProvider = ConversationDataProvider(tableView: chatDialogTableView, with: .Conversation)
        
        conversationModel.fetchedResultsController {[weak self] (frc) in
            
            self?.conversationDataProvider.fetchedResultsController = frc
            self?.conversationDataProvider.performFetch()
            self?.chatDialogTableView.reloadData()
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chatTextField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let scale: CGFloat =  userIsOnline ? 1.1 : 1.0
        navigationItem.titleView?.transform = CGAffineTransform(scaleX: scale, y: scale)
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
                messageCell.textOfMessage = message.textOfMessage
            }
            return cell
        }
        else {
            let   cell = tableView.dequeueReusableCell(withIdentifier: "incomingCell")!
            if let messageCell = cell as? ChatTableViewCell {
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
                            self?.sendButtonIsActive = false
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
 
        if self.chatTextField?.text == "" {
            self.sendButtonIsActive = false
        } else {
            if userIsOnline  {
                if self.sendButtonIsActive == false {
                    self.sendButtonIsActive = true
                }
            }
        }
    }
    
  
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
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



