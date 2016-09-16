//
//  ViewModelServices.swift
//  Reactive Flickr
//
//  Created by igor on 8/2/16.
//  Copyright © 2016 igor. All rights reserved.
//

import RxSwift
import Foundation


protocol ViewModelServices {
    /**
     Forward navigation betwwen View Models
     
     - parameter viewModel: Viem Model to be pushed
     
     */
    func pushViewModel(viewModel: AnyObject)
    
    /**
     Send Flickr search request and get the results
     
     - parameter string: Request string
     
     - returns: Search results observable
     */
    func getFlickrSearchService(string: String) -> Observable<AnyObject>
}

class ViewModelServicesImpl: NSObject, ViewModelServices {
    var flickrSearchService: FlickrSearchImpl?
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        flickrSearchService = FlickrSearchImpl()
        
    }
    
    // MARK: - ViewModelServices methods
    
    func pushViewModel(viewModel: AnyObject) {
        
    }
    
    func getFlickrSearchService(string: String) -> Observable<AnyObject> {
        return flickrSearchService!.flickrSearchSignal(string)
    }
    
    
    
}