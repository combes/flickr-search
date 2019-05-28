//
//  Photo.swift
//  FlickrApp
//
//  Created by Christopher Combes on 5/17/19.
//  Copyright © 2019 Christopher Combes. All rights reserved.
//

import Foundation

struct Photos: Codable {
    let perpage: Int
    let pages: Int
    let photo: [Photo]
    let total: String
    let page: Int
}

struct Photo: Codable {
    let title: String
    let url_t: String
}
