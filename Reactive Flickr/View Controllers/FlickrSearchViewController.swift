//
//  FlickrSearchViewController.swift
//  Reactive Flickr
//
//  Created by igor on 7/29/16.
//  Copyright © 2016 igor. All rights reserved.
//

import ReactiveCocoa
import RxSwift
import RxCocoa
import UIKit

class FlickrSearchViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchHistoryTable: UITableView!
    var viewModel: FlickrSearchViewModel?
    let disposeBag = DisposeBag()
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    
    // MARK - Helper methods
    
    private func bindViewModel() {
        title = viewModel!.title
        searchButton.rx_action = viewModel!.searchAction
        searchTextField.rx_text.bindTo(viewModel!.searchTextVariable).addDisposableTo(disposeBag)
        viewModel!.searchAction?.executing.bindTo(UIApplication.sharedApplication().rx_networkActivityIndicatorVisible).addDisposableTo(disposeBag)
        viewModel!.searchAction?.executing.bindTo(activityIndicator.rx_animating).addDisposableTo(disposeBag)
        viewModel!.searchAction?.executing.map({!$0}).bindTo(activityIndicator.rx_hidden).addDisposableTo(disposeBag)
        viewModel!.searchAction?.executing.subscribeNext {
            print("executing: \($0)")
            }
            .addDisposableTo(disposeBag)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
