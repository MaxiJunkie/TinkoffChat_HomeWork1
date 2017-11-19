//
//  NetworkImagesViewController.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 17.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit

class NetworkImagesViewController: UIViewController {

    @IBOutlet weak var networkImagesCollectionView: UICollectionView!
 
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
    
    var networkImagesModel: INetworkImagesModel!
    
    var imagesUrl: [String] = []
    
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
        
        cell.tag = indexPath.row
        
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.numberOfCell = indexPath.row
            imageCell.imageUrl = self.imagesUrl[indexPath.row]
   
        }
        
        return cell
    }
    
}

extension NetworkImagesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let presenter = presentingViewController as? ProfileViewController {
        
            DispatchQueue.global(qos: .userInitiated).async {[weak self]  in
              
                guard let imageUrl = self?.imagesUrl[indexPath.row] else {return }
                
                guard let url = URL(string: imageUrl) else {return}
                
                let contentsOfURL = try? Data(contentsOf: url)
        
                if  let imageData = contentsOfURL  {
                    DispatchQueue.main.async {
                        presenter.imageProfile = UIImage.init(data: imageData)
                      
                    }
                }
            }
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

