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
        requestTopEntries()
    }
    
    var titleNavigationBar: String {
        return "Reddit Posts"
    }
    
    var titleDismissAllButton: String {
        return "Dismiss All"
    }
    
    func getRedditEntrie(index: Int) -> RedditEntrie? {
        return _topEntries[safe: index]?.data
    }
    
    func numberOfRows() -> Int {
        return _topEntries.count
    }
    
    func deletePost(index: Int) {
        _topEntries.removeAt(safeIndex: index)
    }
    
    func deleteAllPosts() {
        _topEntries.removeAll()
    }
    
    func getRedditDetailsViewModel(redditEntrie: RedditEntrie) -> RedditDetailsViewModel {
        return RedditDetailsViewModel(redditEntrie: redditEntrie)
    }
    
    func visitedRedditEntrie(index: Int) {
        getRedditEntrie(index: index)?.changeVisited(visited: true)
    }
}

private extension RedditListViewModel {
    func requestTopEntries() {
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
