//
//  FlickrClient.swift
//  FlickrApp
//
//  Created by Christopher Combes on 5/27/19.
//  Copyright © 2019 Christopher Combes. All rights reserved.
//

import Foundation

final class FlickrClient {
    
    let basePath = "https://api.flickr.com/services/rest/?method=flickr.photos.search"
    let apiKey = "7ba13e8ee4ffb30beba4e6357f708ea3"
    let photosPerPage = 100
    let session: URLSession
    var task: URLSessionDataTask?
    let cache = DataCache<PagedSearchResponse>()

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func search(query: String, page: Int, completion: @escaping (Result<PagedSearchResponse, ResponseError>) -> Void) {

        if let dataTask = task {
            dataTask.cancel()
        } 

        let url = buildUrl(searchQuery: query, page: page)
        
        if let pageObject = cache.load(path: url.absoluteString) {
            debugPrint("Fetched page \(page) from cache")
        
            // FIXME: Crash occurs if we simply call "completion".
            // We are still on the main thread here, whereas the data task below is on a separate thread.
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { 
                completion(Result.success(pageObject))
            }
            
            return
        }
        
        debugPrint("Fetching page \(page)")
                
        task = session.dataTask(with: url, completionHandler: { [weak self] data, response, error in
        
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(Result.failure(ResponseError.network))
                    return
            }
            
            do {
//                let json = data.prettyPrintedJSONString!
//                debugPrint(json)

                let decodeResponse = try JSONDecoder().decode(PagedSearchResponse.self, from: data)
                self?.cache.store(path: url.absoluteString, object: decodeResponse)
                completion(Result.success(decodeResponse))
            } catch let parsingError {
                debugPrint("Failed to decode: \(parsingError.localizedDescription)")
                completion(Result.failure(ResponseError.decoding))
            }
            
        })
        
        task?.resume()        
    }
}

extension FlickrClient {
    private func buildUrl(searchQuery: String, page: Int = 1) -> URL {
        var components = URLComponents(string: "\(basePath)&api_key=\(apiKey)&format=json&safe_search=1&extras=url_t&nojsoncallback=1&page=\(page)")
        var currentQueryItems = components?.queryItems ?? []
        
        currentQueryItems.append(URLQueryItem(name: "text", value: searchQuery))
        components?.queryItems = currentQueryItems
        
        return components!.url!
    }
}
