//
//  RedditEntrie.swift
//  RedditProject
//
//  Created by Ivan Bober on 08/12/2020.
//

import Foundation

struct RedditEntrie: Codable {
    let title: String
    let author: String
    let created: Int
    let thumbnail: String
    let num_comments: Int
    let visited: Bool
}
