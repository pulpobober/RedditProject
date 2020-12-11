//
//  RedditListViewModel.swift
//  RedditProject
//
//  Created by Ivan Bober on 08/12/2020.
//

import Foundation
import RxSwift

class RedditListViewModel {
    
    private let _disposeBag = DisposeBag()
    private let _redditService = RedditService.shared
    private var _topEntries: [ResultTopEntries] = []
    
    private let _reloadTable = PublishSubject<()>()
    let reloadTable: Observable<()>

    init() {
        reloadTable = _reloadTable
        requestTokenService()
    }
    
    var titleNavigationBar: String {
        return "Reddit Posts"
    }
    
    var titleDismissAllButton: String {
        return "Dismiss All"
    }
    
    public func getRedditEntrie(index: Int) -> RedditEntrie? {
        return _topEntries[safe: index]?.data
    }
    
    public func numberOfRows() -> Int {
        return _topEntries.count
    }
    
    private func requestTokenService() {
        
        _redditService
            .requestToken()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] token in
                //TODO: Esto?
                NetworkConfigs.sharedInstance.accessToken = token
                self?.requestTopEntries()
            })
            .disposed(by: _disposeBag)
    }
    
    private func requestTopEntries() {
        RedditService.shared
            .getTopEntries()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] entries in
                self?._topEntries = entries
                self?._reloadTable.onNext(())
            })
            .disposed(by: self._disposeBag)
    }
    
    
}
