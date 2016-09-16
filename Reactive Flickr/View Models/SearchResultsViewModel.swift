//
//  SearchResultsViewModel.swift
//  Reactive Flickr
//
//  Created by igor on 8/8/16.
//  Copyright © 2016 igor. All rights reserved.
//

import UIKit

class SearchResultsViewModel: NSObject {

    // MARK: - Properties
    
    let title: String
    let searchResults: [AnyObject]
    let viewModelServices: ViewModelServices
    
    // MARK: - Lifecycle
    
    init(services: ViewModelServices, searchResults: FlickrSearchResults) {
        title = "Search Results"
        viewModelServices = services
        self.searchResults = searchResults.photos!
        super.init()
    }
}

