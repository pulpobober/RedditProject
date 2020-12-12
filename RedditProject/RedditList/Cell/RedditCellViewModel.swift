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
    
    var date: String {
        let timeInterval = TimeInterval(redditEntrie.created)
        let postDate = Date(timeIntervalSince1970: timeInterval)
        let nowDate = Date()
        let diffComponents = Calendar.current.dateComponents([.hour], from: postDate, to: nowDate)
        let hoursAgo = diffComponents.hour ?? 0
        return "\(hoursAgo) hours ago"
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
