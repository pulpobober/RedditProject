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
    let numComments: Int
    let visited: Bool
}

extension RedditEntrie {
    enum CodingKeys: String, CodingKey {
        case title
        case author
        case created
        case thumbnail
        case visited
        
        case numComments = "num_comments"
    }
}
