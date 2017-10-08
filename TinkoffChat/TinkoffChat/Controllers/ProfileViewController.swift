//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 20.09.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    
    @IBOutlet weak var editButtonlabel: UIButton!
    @IBOutlet weak var selectProfilePhotoButtonLabel: UIButton!
    @IBOutlet weak var placeholderPhotoProfile: UIImageView!
    


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
      super.viewWillAppear(animated)
   
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        self.editButtonlabel.layer.borderWidth = 1.5
        self.editButtonlabel.layer.cornerRadius = self.editButtonlabel.bounds.height/4
        self.placeholderPhotoProfile.layer.masksToBounds = true
        self.selectProfilePhotoButtonLabel.layer.masksToBounds = true
        self.selectProfilePhotoButtonLabel.layer.cornerRadius = self.selectProfilePhotoButtonLabel.bounds.height/2
        self.placeholderPhotoProfile.layer.cornerRadius = self.selectProfilePhotoButtonLabel.layer.cornerRadius
        self.selectProfilePhotoButtonLabel.layer.cornerRadius = self.selectProfilePhotoButtonLabel.bounds.height/2
        self.placeholderPhotoProfile.layer.cornerRadius = self.selectProfilePhotoButtonLabel.layer.cornerRadius
       
        let offsetOfButton = self.selectProfilePhotoButtonLabel.bounds.height/5
        self.selectProfilePhotoButtonLabel.imageEdgeInsets = UIEdgeInsetsMake(offsetOfButton, offsetOfButton, offsetOfButton, offsetOfButton)
        
    }
    
    
    // MARK - Actions
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        
        
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
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    

}



