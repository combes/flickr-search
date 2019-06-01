//
//  PhotosViewModel.swift
//  FlickrApp
//
//  Created by Christopher Combes on 5/27/19.
//  Copyright © 2019 Christopher Combes. All rights reserved.
//

import Foundation

protocol PhotosViewModelDelegate: class {
    func onFetchCompleted(with pathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class PhotosViewModel {
    private weak var delegate: PhotosViewModelDelegate?
    
    private var photos: [Photo] = []
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    private var query = "" {
        willSet {
            if newValue != query {
                // Reset on new queries
                reset()
            }
        }
    }
    
    let client = FlickrClient()
    
    init(delegate: PhotosViewModelDelegate) {
        self.delegate = delegate
    }
    
    var currentCount: Int {
        return photos.count
    }
    
    func photo(at index: Int) -> Photo? {
        if index < photos.count {
            return photos[index]
        }
        return nil
    }
    
    func reset() {
        currentPage = 1
        total = 0
        photos = []                
    }
    
    func fetchPhotos(query: String) {

        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true

        self.query = query
        
        client.search(query: query, page: currentPage) { (result) in

            switch result {

            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }

            case .success(let response):
                DispatchQueue.main.async {

                    self.currentPage += 1
                    self.isFetchInProgress = false

                    if let total = Int(response.photos.total) {
                        self.total = total
                    }

                    self.photos.append(contentsOf: response.photos.photo)
                    
                    if response.photos.page > 0 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response.photos.photo)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newPhotos: [Photo]) -> [IndexPath] {
        let startIndex = photos.count - newPhotos.count 
        let endIndex = startIndex + newPhotos.count 
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}
