//
//  HTTPResponse.swift
//  FlickrApp
//
//  Created by Christopher Combes on 5/27/19.
//  Copyright © 2019 Christopher Combes. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
