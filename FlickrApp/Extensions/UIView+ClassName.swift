//
//  UIView+ClassName.swift
//  FlickrApp
//
//  Created by Christopher Combes on 5/18/19.
//  Copyright © 2019 Christopher Combes. All rights reserved.
//

import UIKit

extension UIView {
    static var className: String {
        return String(describing: self)
    }
}

