//
//  ImageCollectionViewCell.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 17.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageInCell: UIImageView!
    
    var imageUrl: String? {didSet { updateUI() } }

    var numberOfCell: Int = 0
    
    private func updateUI() {
        if let url = imageUrl {
            self.setImageView(with: url)
        }
    }
   
    
    override func prepareForReuse() {
        self.imageUrl = nil
        self.imageInCell?.image = UIImage.init(named: "placeholder")
        super.prepareForReuse()
    }
    
    
    private func setImageView(with url: String) {
        
        DispatchQueue.global(qos: .userInitiated).async {[weak self]  in
            
            guard let url = URL(string: url) else {return}
            
            let contentsOfURL = try? Data(contentsOf: url)
               if  let imageData = contentsOfURL  {
                DispatchQueue.main.async { [weak self] in
               
                    self?.imageInCell?.image = UIImage(data: imageData)
                }
            }
        }
    }
}
