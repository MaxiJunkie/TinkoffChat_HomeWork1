//
//  NetworkImagesViewController.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 17.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit

class NetworkImagesViewController: AnimationViewController {

    @IBOutlet weak var networkImagesCollectionView: UICollectionView!
 
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
    
    var networkImagesModel: INetworkImagesModel!
    
    var imagesUrl: [String] = []
    var images : [String:UIImage] = [:]
    
    static func initNetworkImagesVC(with model: INetworkImagesModel) -> NetworkImagesViewController {
        let networkImagesVC = UIStoryboard(name: "NetworkImages", bundle: nil).instantiateViewController(withIdentifier: "NetworkImagesViewController") as! NetworkImagesViewController
        networkImagesVC.networkImagesModel = model
        return networkImagesVC
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.networkImagesCollectionView.dataSource = self
        self.networkImagesCollectionView.delegate = self
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()
        
        networkImagesModel.fetchNewImages()
    }

 
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension NetworkImagesViewController: UICollectionViewDataSource {
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesUrl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        

        if let imageCell = cell as? ImageCollectionViewCell {
     
            let url = self.imagesUrl[indexPath.row]
          
            imageCell.imageInCell.image = UIImage.init(named: "placeholder")
            
            if let cachedImage = self.images[self.imagesUrl[indexPath.row]]  {
                
                imageCell.imageInCell?.image = cachedImage
               
            } else {
                
                networkImagesModel.fetchImage(with: self.imagesUrl[indexPath.row], completionHandler: { (image, error) in
                    DispatchQueue.main.async { [weak self] in
                        imageCell.imageInCell?.image = image?.image
                        self?.images[url] = imageCell.imageInCell?.image
                    }
                })
            }
        }
       
        return cell
    }
    
}

extension NetworkImagesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let presenter = presentingViewController as? ProfileViewController {
            
            presenter.activityIndicator.startAnimating()
            networkImagesModel.fetchImage(with: self.imagesUrl[indexPath.row], completionHandler: { (image, error) in
                DispatchQueue.main.async {
                    presenter.imageProfile = image?.image
                    presenter.activityIndicator.stopAnimating()
                }
            })
            
        }
        self.dismiss(animated: true, completion: nil)
    }
}


extension NetworkImagesViewController: UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
}

extension NetworkImagesViewController: INetworkImagesModelDelegate {
    func setup(imagesUrl: [String]) {
       
        self.imagesUrl = imagesUrl
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.networkImagesCollectionView.reloadData()
        }
    }
}

