//
//  ViewController.swift
//  FlickrApp
//
//  Created by Christopher Combes on 5/17/19.
//  Copyright © 2019 Christopher Combes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    private var viewModel: PhotosViewModel!
    private var searchText = ""
    private let itemSpacing: CGFloat = 4
    private lazy var itemSize = view.bounds.width / 3 - itemSpacing
    private var lastContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        
        viewModel = PhotosViewModel(delegate: self)
        
        setupCollectionLayout()
    }
}

extension ViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView.isDragging else {
            return
        }
        
        if abs(lastContentOffset - scrollView.contentOffset.y) > 20 {
            lastContentOffset = scrollView.contentOffset.y;
        }
        
        if lastContentOffset < scrollView.contentOffset.y {
            let dataOffset = collectionView.contentSize.height - collectionView.contentOffset.y - collectionView.bounds.height
            
            if dataOffset < itemSize {
                viewModel.fetchPhotos(query: searchText)
            }
        }
    }    
}

private extension ViewController {
    func setupCollectionLayout() {                
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: itemSpacing, bottom: 0, right: itemSpacing)        
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleItems = collectionView.indexPathsForVisibleItems 
        let indexPathsIntersection = Set(indexPathsForVisibleItems).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.className, for: indexPath) as? PhotoCollectionViewCell {
            
            if let photo = viewModel.photo(at: indexPath.row) {
                cell.configure(photo: photo)
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.currentCount
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        searchText = text
        
        searchBar.resignFirstResponder()
        
        fetchData()        
    }    
    
    func fetchData() {
        activityView.startAnimating()        
        viewModel.fetchPhotos(query: searchText)        
    }
}

extension ViewController: PhotosViewModelDelegate {
    func onFetchCompleted(with pathsToReload: [IndexPath]?) {
        
        activityView.stopAnimating()
        
        guard let newIndexPathsToReload = pathsToReload else {
            collectionView.reloadData()
            return
        }
        
        collectionView.insertItems(at: newIndexPathsToReload)
    }
    
    func onFetchFailed(with reason: String) {
        activityView.stopAnimating()
        
        let alertController = UIAlertController(title: "Warning", message: reason, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
