//
//  RedditDetailsViewModel.swift
//  RedditProject
//
//  Created by Ivan Bober on 13/12/2020.
//

import Foundation

class RedditDetailsViewModel {
    private let redditEntrie: RedditEntrie
    
    public init(redditEntrie: RedditEntrie) {
        self.redditEntrie = redditEntrie
    }
    
    var author: String {
        return redditEntrie.author
    }
    
    var title: String {
        return redditEntrie.title
    }

    var thumbURL: URL? {
        return URL(string: redditEntrie.thumbnail)
    }
}
