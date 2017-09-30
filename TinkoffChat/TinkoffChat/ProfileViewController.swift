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
        
        if self.editButtonlabel != nil {
            if let frame = self.editButtonlabel?.frame {
                print (frame)
            }
        } else {
            print ("editButtonlabel no exist")
        }

        /*
             Проблема возникла в результате того что самой кнопки как объекта еще не существует в момент работы init, соответсвенно
             нельзя получить frame того чего нет. p.s. что мертво умереть не может )))
        */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.editButtonlabel != nil {
            if let frame = self.editButtonlabel?.frame {
                 print (frame)
            }
        } else {
            print ("editButtonlabel no exist")
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
      super.viewWillAppear(animated)
   
        if self.editButtonlabel != nil {
            if let frame = self.editButtonlabel?.frame {
                print (frame)
            }
        } else {
            print ("editButtonlabel no exist")
        }
        
         /*
             Здесь frame не отличается от того что в viewDidLoad
         */
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if self.editButtonlabel != nil {
            if let frame = self.editButtonlabel?.frame {
                print (frame)
            }
        } else {
            print ("editButtonlabel no exist")
        }
        
        /*
             После наложения constrait к моменту viewDidAppear происходит изменение frame у editbutton
             Обращаю внимание что если запустить на iphone 5 или SE, то frame будет одинаковый так как весь перерасчет идет относительно того что находиться в interface builder
        */
        
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
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        
        
    }
    
    @IBAction func selectProfilePhotoAction(_ sender: Any) {
        
        print ("Choose image profile")
        
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



