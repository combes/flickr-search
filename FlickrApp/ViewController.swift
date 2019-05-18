//
//  ViewController.swift
//  FlickrApp
//
//  Created by Christopher Combes on 5/17/19.
//  Copyright © 2019 Christopher Combes. All rights reserved.
//

import UIKit

// TODO: Add pagination
class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    let service = FlickrService()
    var photos: [Photo]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionLayout()
    }
}

private extension ViewController {
    func setupCollectionLayout() {
        let spacing: CGFloat = 4
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        let itemSize = view.bounds.width / 3 - spacing
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell {
            
            if let photo = photos?[indexPath.row] {
                cell.configure(path: photo.url_t)
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        activityView.startAnimating()
        
        service.search(query: text) { [weak self] (photos, error) in
            
            DispatchQueue.main.async {
                self?.activityView.stopAnimating()
                
                if let error = error {
                    print("No items found \(error.localizedDescription)")
                } else {
                    self?.photos = photos
                }
            }
        }        
    }
}
