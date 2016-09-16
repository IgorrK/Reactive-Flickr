//
//  FlickrSearch.swift
//  Reactive Flickr
//
//  Created by igor on 8/2/16.
//  Copyright © 2016 igor. All rights reserved.
//

import Foundation
//import ReactiveCocoa
//import Bond
import RxSwift
import RxCocoa
import objectiveflickr

private let APIKey = "2d9243e3a5fd36ce544c46480933c104"
private let SharedSecret = "067c6e927d61e5fd"

protocol FlickrSearch {
    func flickrSearchSignal(string: String) -> Observable<AnyObject>
}

class FlickrSearchImpl: NSObject, FlickrSearch, OFFlickrAPIRequestDelegate {
    var requests = Set<OFFlickrAPIRequest>()
    var flickrContext: OFFlickrAPIContext
    let disposeBag = DisposeBag()
    
    override init() {
        flickrContext = OFFlickrAPIContext(APIKey: APIKey, sharedSecret: SharedSecret)
        super.init()
    }
    
    func flickrSearchSignal(string: String) -> Observable<AnyObject> {
        return observeAPIMethod("flickr.photos.search",
                                arguments: ["text" : string, "sort" : "interestingness-desc"]) { (response: [String : AnyObject]) -> AnyObject in
                                    let searchResults = FlickrSearchResults()
                                                    searchResults.searchString = string
                                    guard let photos = response["photos"] as? [String : AnyObject] else {
                                        return "error"   // TODO: error handling
                                    }
                                    guard let total = photos["total"] as? String else {
                                        return "error"
                                    }
                                    searchResults.totalResults = UInt(total)
                                    
                                    guard let photosArray = photos["photo"] as? [[String : AnyObject]] else {
                                        return "error"
                                    }
                                    var flickrPhotosArray = [FlickrPhoto]()
                                    for photoData: [String : AnyObject] in photosArray {
                                        guard let title = photoData["title"], identifier = photoData["id"] else {
                                            continue
                                        }
                                        let photo = FlickrPhoto()
                                        photo.title = title as? String
                                        photo.identifier = identifier as? String
                                        photo.url = self.flickrContext.photoSourceURLFromDictionary(photoData, size: OFFlickrSmallSize)
                                        flickrPhotosArray.append(photo)
                                    }
                                    searchResults.photos = flickrPhotosArray
                                    return(searchResults)
                                    
        }.asObservable()
//            .subscribeNext { val in
//            print("subscribe")
//        }
//        return Observable.empty().delaySubscription(2.0, scheduler: MainScheduler.instance).debug()
    }
    
    func observeAPIMethod(method: String, arguments: [String : AnyObject], transform: ([String : AnyObject]) -> AnyObject) -> Observable<AnyObject>{
        return Observable.create { observer in
            let flickrRequest = OFFlickrAPIRequest(APIContext: self.flickrContext)
            flickrRequest.delegate = self
            self.requests.insert(flickrRequest)
            
            flickrRequest.rx_didCompleteWithResponse
                .map { params in
                    return params[1] as! [String : AnyObject]
                }
                .map(transform)
                .subscribeNext { element in
                    observer.on(Event.Next(element))
                    observer.on(Event.Completed)
                }
                .addDisposableTo(self.disposeBag)
            
            flickrRequest.callAPIMethodWithGET(method, arguments: arguments)

            
//            return Observable.empty().subscribe { val in
//                print("disposable: \(val)")
//                self.requests.remove(flickrRequest)
//            }
//            self.requests .remove(flickrRequest)
            return NopDisposable.instance
        }
//        return Observable.empty()
    }
    
}

extension OFFlickrAPIRequest {
    
    public var rx_delegate: DelegateProxy {
        return OFFlickrAPIRequestDelegateProxy.proxyForObject(self)
    }
    
    public var rx_didCompleteWithResponse: Observable<[AnyObject]> {
        return rx_delegate.observe(#selector(OFFlickrAPIRequestDelegate.flickrAPIRequest(_:didCompleteWithResponse:)))
    }

    public var rx_didFailWithError: Observable<NSError> {
        return rx_delegate.observe(#selector(OFFlickrAPIRequestDelegate.flickrAPIRequest(_:didFailWithError:)))
            .map { params in
                return params[1] as! NSError
        }
    }
}

class OFFlickrAPIRequestDelegateProxy: DelegateProxy, OFFlickrAPIRequestDelegate, DelegateProxyType {
    //We need a way to read the current delegate
    static func currentDelegateFor(object: AnyObject) -> AnyObject? {
        let request: OFFlickrAPIRequest = object as! OFFlickrAPIRequest
        return request.delegate
    }
    //We need a way to set the current delegate
    static func setCurrentDelegate(delegate: AnyObject?, toObject object: AnyObject) {
        let request: OFFlickrAPIRequest = object as! OFFlickrAPIRequest
        request.delegate = delegate as? OFFlickrAPIRequestDelegate
    }
}