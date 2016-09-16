//
//  File.swift
//  Reactive Flickr
//
//  Created by GlebRadchenko on 7/29/16.
//  Copyright © 2016 igor. All rights reserved.
//

import Foundation
import UIKit

class Injector: NSObject, UINavigationControllerDelegate {
    
    @IBOutlet weak var flickrSearchViewController: FlickrSearchViewController! {
        didSet {
            configure()
        }
    }
    @IBOutlet weak var searchResultsViewController: SearchResultsViewController! {
        didSet {
            let flickrSearchViewModel = flickrSearchViewController.viewModel as FlickrSearchViewModel!
            searchResultsViewController.viewModel = SearchResultsViewModel(services: flickrSearchViewModel.viewModelServices,
                                                                           searchResults: flickrSearchViewModel.searchResults!)

        }
    }
    
    func configure() {
        flickrSearchViewController.viewModel = FlickrSearchViewModel(services: ViewModelServicesImpl())
    }
}