//
//  ResponseError.swift
//  FlickrApp
//
//  Created by Christopher Combes on 5/27/19.
//  Copyright © 2019 Christopher Combes. All rights reserved.
//

import Foundation

enum ResponseError: Error {
    case network
    case decoding
    
    var reason: String {
        switch self {
        case .network:
            return "An error occurred while fetching data"
        case .decoding:
            return "An error occurred while decoding data"
        }
    }
}
