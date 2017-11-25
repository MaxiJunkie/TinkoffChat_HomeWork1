//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 20.09.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: AnimationViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate, UITextFieldDelegate {

    var settingIsChange = false
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var selectProfilePhotoButton: UIButton!
    @IBOutlet weak var placeholderPhotoProfile: UIImageView!

    var profileDataSetting = ProfileDataInterface.init(with: "", userInfo: "", image: nil) 
    
    
    var imageProfile: UIImage? {
        didSet {
            settingIsChange = true
            self.profileDataSetting.photoImage = imageProfile
            self.placeholderPhotoProfile.contentMode = .scaleAspectFill
            self.placeholderPhotoProfile?.image = imageProfile
            
        }
    }
    
    var nameProfile :String? {
        didSet {
            settingIsChange = true
            self.profileDataSetting.name = nameProfile
            self.userNameTextField?.text = nameProfile
        }
    }
    
    var userDescription: String? {
        didSet {
            settingIsChange = true
            self.profileDataSetting.userInfo = userDescription
            self.infoTextField?.text = userDescription
        }
    }
    
    
    
    
    var profileModel: ProfileModelProtocol!
    
    static func initProfileVC(with model: ProfileModelProtocol) -> ProfileViewController {
        let profileVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        profileVC.profileModel = model
        return profileVC
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.activityIndicator.hidesWhenStopped = true
        self.placeholderPhotoProfile.layer.masksToBounds = true
        self.selectProfilePhotoButton.layer.masksToBounds = true
    
        self.profileModel.readDataFromCoreData(completion: { (profile) in
            
            
            if let name = profile.name {
                self.nameProfile = name
            }
            if let userDescription = profile.userInfo {
                self.userDescription = userDescription
            }
            if let photo = profile.photoImage {
                self.imageProfile = photo
            }
           
            
        }, errorBlock: nil)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.saveButton.layer.borderWidth = 1.5
     
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        self.saveButton.layer.cornerRadius = self.saveButton.bounds.height/4
      
        self.selectProfilePhotoButton.layer.cornerRadius = self.selectProfilePhotoButton.bounds.height/2
        self.placeholderPhotoProfile.layer.cornerRadius = self.selectProfilePhotoButton.layer.cornerRadius
        self.selectProfilePhotoButton.layer.cornerRadius = self.selectProfilePhotoButton.bounds.height/2
        self.placeholderPhotoProfile.layer.cornerRadius = self.selectProfilePhotoButton.layer.cornerRadius
        let offsetOfButton = self.selectProfilePhotoButton.bounds.height/5
        self.selectProfilePhotoButton.imageEdgeInsets = UIEdgeInsetsMake(offsetOfButton, offsetOfButton, offsetOfButton, offsetOfButton)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    
    // MARK - Actions
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
 
    @IBAction func saveButtonAction(_ sender: Any) {
        
        if settingIsChange {
            settingIsChange = false
            self.activityIndicator.startAnimating()
            self.saveButton.isEnabled = false
            self.profileModel.writeDataInCoreData(profileDataSetting, completion: {
                DispatchQueue.main.async { [weak self] in
                    self?.configurateAlert()
                }
            }, errorBlock: { (error) in
                DispatchQueue.main.async { [weak self] in
                    self?.configurateErrorAlert(with: sender)
                }
            })
            }
        }

    
    // MARK - methods for configurate alerts
    
    func configurateAlert() {
        self.activityIndicator.stopAnimating()
        self.saveButton.isEnabled = true
      
        let alert = UIAlertController(title: "Data saved", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func configurateErrorAlert(with sender: Any) {
        
        let alert = UIAlertController(title: "Error", message: "data could not be saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: {
            _ in
            self.activityIndicator.stopAnimating()
            self.saveButton.isEnabled = true
      
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Repeat", comment: "Default action"), style: .`default`, handler: {_ in
            self.settingIsChange = true
            self.saveButtonAction(sender)
          
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func selectProfilePhotoAction(_ sender: Any) {
   
        let alertViewController = UIAlertController(title: "Change Profile Photo", message: nil, preferredStyle: .actionSheet)
        alertViewController.addAction(UIAlertAction(title: "Choose From Library", style: .`default`, handler:  {[weak self] action in
            
            self?.imagePickerWith(sourceType: .photoLibrary)
            
        }))
        alertViewController.addAction(UIAlertAction(title: "Take Photo", style: .`default`, handler: {[weak self] action in
            
            self?.imagePickerWith(sourceType: .camera)
            
        }))
        alertViewController.addAction(UIAlertAction(title: "Load from network", style: .`default`, handler: { action in
            
      
            let niVC = NetworkImagesAssembly().networkImagesViewCotnroller()
            
            self.present(niVC, animated: true, completion: nil)
            
            
        }))
        

        alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
            (alertAction: UIAlertAction!) in
        }))
        self.present(alertViewController, animated: true, completion: nil)
    }
    

    func imagePickerWith(sourceType: UIImagePickerControllerSourceType) {
        
        weak var weakSelf = self
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = weakSelf
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        weakSelf?.present(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
           
            self.imageProfile = pickedImage
        }
        
        self.dismiss(animated: true, completion: nil)
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
            self.selectProfilePhotoButton.isEnabled = false
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            if textField == self.userNameTextField {
                let text = self.profileDataSetting.name ?? ""
                if text != textField.text {
                    self.nameProfile = textField.text
                }
            }else {
                let text = self.profileDataSetting.userInfo ?? ""
                if text != textField.text {
                    self.userDescription = textField.text
            }
        }
        self.selectProfilePhotoButton.isEnabled = true
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
        let changeInHeight = (keyboardFrame.height - self.saveButton.bounds.height * 3 ) * (show ? 1 : -1)
        let view = self.view.bounds.origin.y
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.view.bounds.origin.y = view + changeInHeight
        })
    }
    
}



