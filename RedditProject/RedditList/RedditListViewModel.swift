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
    private let _redditService: RedditServiceProtocol
    private var _topEntries: [ResultTopEntries] = []
    private var _afterPagination: String?
    private let _reloadTable = PublishSubject<()>()
    let reloadTable: Observable<()>
    private let _loadingTransactions = PublishSubject<(Bool)>()
    let loadingTransactions: Observable<Bool>

    init(redditService: RedditServiceProtocol) {
        reloadTable = _reloadTable
        loadingTransactions = _loadingTransactions
        _redditService = redditService
        requestTopEntries(afterPagination: _afterPagination)
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
    
    func requestMorePages() {
        guard _afterPagination != nil else { return }
        requestTopEntries(afterPagination: _afterPagination)
    }
    
    func refreshAllData() {
        deleteAllPosts()
        requestTopEntries(afterPagination: nil)
    }
}

private extension RedditListViewModel {
    func requestTopEntries(afterPagination: String?) {
        _loadingTransactions.onNext(true)
        _redditService
            .getTopEntries(afterPagination: afterPagination)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                self?._loadingTransactions.onNext(false)
                self?._afterPagination = response.after
                self?._topEntries += response.children
                self?._reloadTable.onNext(())
            })
            .disposed(by: self._disposeBag)
    }
}
