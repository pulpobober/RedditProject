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
    
    var date: Int {
        return redditEntrie.created //Es un int
    }
    
    var title: String {
        return redditEntrie.title //Es un int
    }

    var thumbURL: String {
        return redditEntrie.thumbnail //No es una URL
    }
    
    var numComments: String {
        return "\(redditEntrie.num_comments) comments"
    }
    
    
    var dismissButtonTitle: String {
        return "Dismiss Post"
    }
}
