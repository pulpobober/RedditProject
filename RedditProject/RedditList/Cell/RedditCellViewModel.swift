//
//  RedditCellViewModel.swift
//  RedditProject
//
//  Created by Ivan Bober on 10/12/2020.
//

import Foundation

class RedditListCellViewModel {
    
    private let redditEntrie: RedditEntrie
    
    public init(redditEntrie: RedditEntrie) {
        self.redditEntrie = redditEntrie
    }
    
    var author: String {
        return redditEntrie.author
    }
    
    var visited: Bool {
        return redditEntrie.visited
    }
    
    var date: Date {
        //TODO: Hacerlo bien con Int
        let timeInterval = TimeInterval(redditEntrie.created)
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    var title: String {
        return redditEntrie.title
    }

    var thumbURL: URL? {
        return URL(string: redditEntrie.thumbnail)
    }
    
    var numComments: String {
        return "\(redditEntrie.numComments) comments"
    }
    
    
    var dismissButtonTitle: String {
        return "Dismiss Post"
    }
}
