//
//  FakeModels.swift
//  RedditProjectTests
//
//  Created by Ivan Bober on 13/12/2020.
//

import Foundation
@testable import RedditProject

extension RedditResponse {
    static func faked(after: String? = nil, before: String? = nil, children: [ResultTopEntries] = [ResultTopEntries.faked()]) -> RedditResponse {
        return RedditResponse(after: after, before: before, children: children)
    }
}

extension ResultTopEntries {
    static func faked(data: RedditEntrie = RedditEntrie.faked(), kind: String = "") -> ResultTopEntries {
        return ResultTopEntries(data: data, kind: kind)
    }
}

extension RedditEntrie {
    
    static func faked(title: String = "title", author: String = "author", created: Int = 1, thumbnail: String = "", numComments: Int = 1, visited: Bool = true, url: String = "") -> RedditEntrie {
        return RedditEntrie(title: title, author: author, created: created, thumbnail: thumbnail, numComments: numComments, visited: visited, url: url)
    }
}

