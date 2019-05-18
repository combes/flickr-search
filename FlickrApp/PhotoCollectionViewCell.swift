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
    
    func configure(path: String) {
        guard let url = URL(string: path) else {
            print("Could not create URL from \(path)")
            return
        } 
        
        do {
            let data = try Data(contentsOf: url)
            imageView.image = UIImage(data: data)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
