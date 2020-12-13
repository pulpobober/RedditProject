//
//  FakeRespository.swift
//  RedditProjectTests
//
//  Created by Ivan Bober on 13/12/2020.
//

import Foundation
import RxSwift
@testable import RedditProject

class FakeRedditService: RedditServiceProtocol {
    
    var redditResponse: RedditResponse = RedditResponse.faked(after: nil, before: nil, children: [ResultTopEntries.faked(data: RedditEntrie.faked())])
    
    func getTopEntries(afterPagination: String?) -> Observable<RedditResponse> {
        return .just(redditResponse)
    }
    
    
}
