//
//  ViewController.swift
//  RedditProject
//
//  Created by Ivan Bober on 07/12/2020.
//

import UIKit

import RxSwift
class ViewController: UIViewController {
    private let _disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RedditService.shared
            .requestToken().debug("--> requestToken")
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { token in
                NetworkConfigs.sharedInstance.accessToken = token
            })
            .disposed(by: _disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            RedditService.shared
                .getTopEntries().debug("--> getTopEntries")
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { _ in
                    
                })
                .disposed(by: self._disposeBag)
        }
    }
}
