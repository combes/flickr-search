//
//  DataCache.swift
//  FlickrApp
//
//  Created by Christopher Combes on 5/31/19.
//  Copyright © 2019 Christopher Combes. All rights reserved.
//

import Foundation

class DataCache<T> {
    var cache: [String: T] = [:]
    
    func load(path: String) -> T? {
        return cache[path]
    }
    
    func store(path: String, object: T) {
        cache[path] = object
    }
}
