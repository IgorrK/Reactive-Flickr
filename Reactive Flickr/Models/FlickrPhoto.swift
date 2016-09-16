//
//  FlickrPhoto.swift
//  Reactive Flickr
//
//  Created by igor on 8/2/16.
//  Copyright © 2016 igor. All rights reserved.
//

import UIKit

class FlickrPhoto: NSObject {
    var title: String?
    var url: NSURL?
    var identifier: String?
    
    override var description: String {
        guard let title = title else { return "" }
        return title
    }
}
