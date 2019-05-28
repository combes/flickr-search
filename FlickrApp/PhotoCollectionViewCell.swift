//
//  PhotoCollectionViewCell.swift
//  FlickrApp
//
//  Created by Christopher Combes on 5/17/19.
//  Copyright © 2019 Christopher Combes. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(photo: Photo) {
        guard let url = URL(string: photo.url_t) else {
            print("Could not create URL from \(photo.url_t))")
            return
        } 
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
    }
}
