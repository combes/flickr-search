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
    
    static let imageCache = DataCache<UIImage>()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(photo: Photo) {
        
        if let image = PhotoCollectionViewCell.imageCache.load(path: photo.url_t) {
            DispatchQueue.main.async {
                self.imageView.image = image 
            }
            return
        }
        
        guard let url = URL(string: photo.url_t) else {
            print("Could not create URL from \(photo.url_t))")
            return
        } 
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                if let validImage = image {
                    PhotoCollectionViewCell.imageCache.store(path: url.absoluteString, object: validImage)
                }
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
}
