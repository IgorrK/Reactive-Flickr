//
//  FlickrSearchViewModel.swift
//  Reactive Flickr
//
//  Created by igor on 7/29/16.
//  Copyright © 2016 igor. All rights reserved.
//


import RxSwift
import Action
import UIKit


class FlickrSearchViewModel: NSObject {
    
    // MARK: - Properties

    let title: String
    let searchTextVariable = Variable<String>("")
    var searchAction: CocoaAction?
    let viewModelServices: ViewModelServices
    var searchResults: FlickrSearchResults?
    
    
    private var validSearchTextObservable = Observable<Bool>!(nil)
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    init(services: ViewModelServices) {
        viewModelServices = services
        title = "Flickr search"
        super.init()
        
        initialize()
    }
    
    // MARK: - Helper methods
    
    /**
     Configure reactive variables
     */
    func initialize() -> Void {
        searchTextVariable
            .asObservable()
            .subscribeNext {
                print("text: \($0)")
            }
            .addDisposableTo(disposeBag)
        
        // Configure observable for valid search text
        validSearchTextObservable = searchTextVariable
            .asObservable()
            .map({ $0.characters.count > 3 })
        
        // Execute search action for valid search text with 1.0 second throttle
        validSearchTextObservable
            .throttle(1.0, scheduler: MainScheduler.instance)
            .subscribeNext { isValid in
                print("validated: \(isValid)")
                if (isValid == true) {
                    guard let searchAction = self.searchAction else {
                        print("ERROR: action missing")
                        return
                    }
                    searchAction.execute()
                }
            }
            .addDisposableTo(disposeBag)
        
        
        validSearchTextObservable
            .throttle(1.0, scheduler: MainScheduler.instance)
            .subscribeNext { isValid in
                print("validated: \(isValid)")
                if (isValid == true) {
                    guard let searchAction = self.searchAction else {
                        print("ERROR: action missing")
                        return
                    }
                    searchAction.execute()
                }
            }
            .addDisposableTo(disposeBag)

        // Create search CocoaAction
        searchAction = CocoaAction(enabledIf: validSearchTextObservable, workFactory: { input in
            return Observable.create { observer in
                self.viewModelServices.getFlickrSearchService(self.searchTextVariable.value)
                    .subscribeNext { element in
                        guard let searchResults = element as? FlickrSearchResults else {
                            // TODO: setup error
                            let error = NSError(domain: "", code: 0, userInfo: nil)
                            observer.on(Event.Error(error))
                            return
                        }
                        self.searchResults = searchResults
                        observer.on(Event.Completed)
                        
                }
                .addDisposableTo(self.disposeBag)
                return NopDisposable.instance
            }
        })
    }
}

