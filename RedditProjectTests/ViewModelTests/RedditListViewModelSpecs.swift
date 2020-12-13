//
//  RedditListViewModelSpecs.swift
//  RedditProjectTests
//
//  Created by Ivan Bober on 13/12/2020.
//

import Foundation
import Quick
import Nimble
import RxSwift

@testable import RedditProject

class RedditListViewModelSpecs: QuickSpec {
    
    override func spec() {
        var redditListViewModel: RedditListViewModel!
        var redditService: FakeRedditService!
        var disposeBag: DisposeBag!
        
        beforeEach {
            redditService = FakeRedditService()
            disposeBag = DisposeBag()
        }
        
        describe("#numberOfPosts") {

            context("When there are no post") {

                it("should return 0") {
                    redditService.redditResponse = RedditResponse.faked(children: [])
                    redditListViewModel = RedditListViewModel(redditService: redditService)
                    expect(redditListViewModel.numberOfRows()) == 0
                }
            }

            context("When there are post") {

                it("should return the number of posts") {
                    
                    let redditEntrie = RedditEntrie.faked()
                    let resultTopEntries = ResultTopEntries.faked(data: redditEntrie)
                    let response = RedditResponse.faked(children: [resultTopEntries, resultTopEntries])
                    redditService.redditResponse = response
                    redditListViewModel = RedditListViewModel(redditService: redditService)

                    expect(redditListViewModel.numberOfRows()) == 2
                }
            }
        }
        
        describe("#pagination") {

            context("When is the only page") {

                it("should not fetch more pages and not reload table") {
                    
                    redditService.redditResponse = RedditResponse.faked(after: nil)
                    redditListViewModel = RedditListViewModel(redditService: redditService)
                             
                    var reloadTable = false
                    
                    redditListViewModel
                        .reloadTable
                        .subscribe(onNext: { _ in
                            reloadTable = true
                        })
                        .disposed(by: disposeBag)
                    
                    redditListViewModel.requestMorePages()
                    expect(reloadTable) == false
                }
            }
            
            context("When has more pages") {

                it("should fetch more pages and reload Table") {
                    redditService.redditResponse = RedditResponse.faked(after: "page 1")
                    redditListViewModel = RedditListViewModel(redditService: redditService)
                             
                    var reloadTable = false
                    
                    redditListViewModel
                        .reloadTable
                        .subscribe(onNext: { _ in
                            reloadTable = true
                        })
                        .disposed(by: disposeBag)
                    
                    redditListViewModel.requestMorePages()
                    expect(reloadTable) == true
                }
            }
        }
    }
}
