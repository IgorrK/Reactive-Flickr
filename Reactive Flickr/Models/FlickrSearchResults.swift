//
//  FlickrSearchResults.swift
//  Reactive Flickr
//
//  Created by igor on 8/2/16.
//  Copyright © 2016 igor. All rights reserved.
//

import UIKit

class FlickrSearchResults: NSObject {
    var searchString: String?
    var photos: Array<AnyObject>?
    var totalResults: UInt?
    
    override var description: String {
        guard let searchString = searchString, let photos = photos, let totalResults = totalResults else {
            return ""
        }
        return "searchString: \(searchString), totalResults: \(totalResults), photos: \(photos)"
    }
}
