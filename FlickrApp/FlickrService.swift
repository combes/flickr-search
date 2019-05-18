//
//  FlickrService.swift
//  FlickrApp
//
//  Created by Christopher Combes on 5/17/19.
//  Copyright © 2019 Christopher Combes. All rights reserved.
//

import Foundation

final class FlickrService {
    
    func search(query: String, completion: @escaping (([Photo]?, Error?) -> Void)) {
        let url = FlickrService.buildUrl(searchQuery: query)
        
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let error = error {
                completion(nil, error)
            } else if let data = data {
                do {
                    let photoData = try JSONDecoder().decode(PhotoData.self, from: data)
                    completion(photoData.photos.photo, nil)
                } catch let parsingError {
                    print("Error", parsingError)
                    completion(nil, nil)
                }                
            }
            }.resume()        
    }
    
    // https://gist.github.com/bradleyrzeller/dda77fc21a2580e00b31f2611ab275ec    
    private static func buildUrl(searchQuery: String) -> URL {
        var comps = URLComponents(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=a724969f016f0b8badd7e518a6c48e55&format=json&safe_search=1&extras=url_t&nojsoncallback=1")
        var currentQueryItems = comps?.queryItems ?? []
        
        currentQueryItems.append(URLQueryItem(name: "text", value: searchQuery))
        comps?.queryItems = currentQueryItems
        
        return comps!.url!
    }
    
}
