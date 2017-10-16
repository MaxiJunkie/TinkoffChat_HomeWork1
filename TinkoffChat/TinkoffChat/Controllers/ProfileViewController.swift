//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 20.09.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate, UITextFieldDelegate {

    static var settingIsChange = false
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!

    @IBOutlet weak var gcdButtonLabel: UIButton!
    @IBOutlet weak var operationButtonLabel: UIButton!
    @IBOutlet weak var selectProfilePhotoButtonLabel: UIButton!
    @IBOutlet weak var placeholderPhotoProfile: UIImageView!
    
    var dictionaryOfUserSettings = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        GCDDataManager.sharedInstance.readDataFromFile(completion: {[weak self]  dictionary in
          self?.dictionaryOfUserSettings = dictionary
           
            var totalData :Data?
            if let imageData = self?.dictionaryOfUserSettings["imageProfile"] as? String {
                if  let data =  Data(base64Encoded: imageData , options: NSData.Base64DecodingOptions()) {
                    totalData = data
                }
            }
            
            DispatchQueue.main.async {
                
                if let userName = self?.dictionaryOfUserSettings["userName"] as? String {
                    self?.userNameTextField?.text = userName
                }
                if let infoText = self?.dictionaryOfUserSettings["infoText"] as? String {
                      self?.infoTextField?.text = infoText
                }
                
               
                if totalData != nil {
                    self?.placeholderPhotoProfile.contentMode = .scaleAspectFill
                    self?.placeholderPhotoProfile?.image = UIImage(data: totalData!)
                }
                
            }
            
        }, errorBlock: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.activityIndicator.hidesWhenStopped = true
        self.gcdButtonLabel.layer.borderWidth = 1.5
        self.gcdButtonLabel.layer.cornerRadius = self.gcdButtonLabel.bounds.height/4
        self.operationButtonLabel.layer.borderWidth = 1.5
        self.operationButtonLabel.layer.cornerRadius = self.gcdButtonLabel.bounds.height/4
        self.placeholderPhotoProfile.layer.masksToBounds = true
        self.selectProfilePhotoButtonLabel.layer.masksToBounds = true
        self.selectProfilePhotoButtonLabel.layer.cornerRadius = self.selectProfilePhotoButtonLabel.bounds.height/2
        self.placeholderPhotoProfile.layer.cornerRadius = self.selectProfilePhotoButtonLabel.layer.cornerRadius
        self.selectProfilePhotoButtonLabel.layer.cornerRadius = self.selectProfilePhotoButtonLabel.bounds.height/2
        self.placeholderPhotoProfile.layer.cornerRadius = self.selectProfilePhotoButtonLabel.layer.cornerRadius
       
        let offsetOfButton = self.selectProfilePhotoButtonLabel.bounds.height/5
        self.selectProfilePhotoButtonLabel.imageEdgeInsets = UIEdgeInsetsMake(offsetOfButton, offsetOfButton, offsetOfButton, offsetOfButton)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    
    // MARK - Actions
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
 
    @IBAction func gcdButtonAction(_ sender: Any) {
        
        if ProfileViewController.settingIsChange {
            ProfileViewController.settingIsChange = false
            self.activityIndicator.startAnimating()
            self.gcdButtonLabel.isEnabled = false
            self.operationButtonLabel.isEnabled = false
            GCDDataManager.sharedInstance.writeDataInFile(self.dictionaryOfUserSettings, completion: {
                [weak self] in
                DispatchQueue.main.async {
                
                    self?.activityIndicator.stopAnimating()
                    self?.gcdButtonLabel.isEnabled = true
                    self?.operationButtonLabel.isEnabled = true
                    let alert = UIAlertController(title: "Data saved", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }}, errorBlock: {[weak self]  error in
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "data could not be saved", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: {
                            _ in
                            self?.activityIndicator.stopAnimating()
                            self?.gcdButtonLabel.isEnabled = true
                            self?.operationButtonLabel.isEnabled = true
                        }))
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Repeat", comment: "Default action"), style: .`default`, handler: {
                            _ in
                            ProfileViewController.settingIsChange = true
                            self?.gcdButtonAction(sender)
                        }))
                        self?.present(alert, animated: true, completion: nil)
                    }
                })
            }
        }
    
    @IBAction func operationButtonAction(_ sender: UIButton) {
       
        if ProfileViewController.settingIsChange {
            ProfileViewController.settingIsChange = false
            self.activityIndicator.startAnimating()
            self.gcdButtonLabel.isEnabled = false
            self.operationButtonLabel.isEnabled = false
            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = 1
            let operation = OperationDataManager()
            operation.operationDictionary = dictionaryOfUserSettings
            queue.addOperation(operation)
            operation.completionBlock = { [weak self] in
                
               let mainQueue = OperationQueue.main
                if operation.errorBlock != nil {
                     mainQueue.addOperation({
                        let alert = UIAlertController(title: "Error", message: "data could not be saved", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: {
                            _ in
                            self?.activityIndicator.stopAnimating()
                            self?.gcdButtonLabel.isEnabled = true
                            self?.operationButtonLabel.isEnabled = true
                        }))
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Repeat", comment: "Default action"), style: .`default`, handler: {
                            _ in
                            ProfileViewController.settingIsChange = true
                            self?.operationButtonAction(sender)
                        }))
                        self?.present(alert, animated: true, completion: nil)
                     })
                } else {
                    mainQueue.addOperation({
                        self?.activityIndicator.stopAnimating()
                        self?.gcdButtonLabel.isEnabled = true
                        self?.operationButtonLabel.isEnabled = true
                        let alert = UIAlertController(title: "Data saved", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    })
                }
            }
        }
    }
    
    
    @IBAction func selectProfilePhotoAction(_ sender: Any) {
   
        let alertViewController = UIAlertController(title: "Change Profile Photo", message: nil, preferredStyle: .actionSheet)
        alertViewController.addAction(UIAlertAction(title: "Choose From Library", style: .`default`, handler:  {[weak self] action in
            
            self?.imagePickerWith(sourceType: .photoLibrary)
            
        }))
        alertViewController.addAction(UIAlertAction(title: "Take Photo", style: .`default`, handler: {[weak self] action in
            
            self?.imagePickerWith(sourceType: .camera)
            
        }))
        alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
            (alertAction: UIAlertAction!) in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    

    func imagePickerWith(sourceType: UIImagePickerControllerSourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.placeholderPhotoProfile.contentMode = .scaleAspectFill
            self.placeholderPhotoProfile.image = pickedImage
            self.updateDataImage()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func updateDataImage() {
        if let image = self.placeholderPhotoProfile?.image {
            if let data = UIImagePNGRepresentation(image)?.base64EncodedData() {
                ProfileViewController.settingIsChange = true
                self.dictionaryOfUserSettings["imageProfile"] =  String(data: data, encoding: .utf8)
            }
        }
    }
    
    // MARK - UITextFieldDelegate
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.userNameTextField {
            self.infoTextField.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.isFirstResponder {
            self.selectProfilePhotoButtonLabel.isEnabled = false
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            if textField == self.userNameTextField {
                let text = self.dictionaryOfUserSettings["userName"] as? String ?? ""
                if text != textField.text {
                    ProfileViewController.settingIsChange = true
                    self.dictionaryOfUserSettings["userName"] = textField.text
                }
            }else {
                let text = self.dictionaryOfUserSettings["infoText"] as? String ?? ""
                if text != textField.text {
                    ProfileViewController.settingIsChange = true
                    self.dictionaryOfUserSettings["infoText"] = textField.text
            }
        }
        self.selectProfilePhotoButtonLabel.isEnabled = true
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
        let changeInHeight = (keyboardFrame.height - self.operationButtonLabel.bounds.height * 3 ) * (show ? 1 : -1)
        let view = self.view.bounds.origin.y
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.view.bounds.origin.y = view + changeInHeight
        })
    }
    
}



