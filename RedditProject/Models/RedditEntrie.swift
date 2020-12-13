//
//  RedditEntrie.swift
//  RedditProject
//
//  Created by Ivan Bober on 08/12/2020.
//

import Foundation

//I have to use a Class instead of a struct because I want to modify the "visited" element
class RedditEntrie: Codable {
    let title: String
    let author: String
    let created: Int
    let thumbnail: String
    let numComments: Int
    var visited: Bool
    let url: String
    
    init(title: String, author: String, created: Int, thumbnail: String, numComments: Int, visited: Bool, url: String) {
        self.title = title
        self.author = author
        self.created = created
        self.thumbnail = thumbnail
        self.numComments = numComments
        self.visited = visited
        self.url = url
    }
}

extension RedditEntrie {
    enum CodingKeys: String, CodingKey {
        case title
        case author
        case created
        case thumbnail
        case visited
        case url
        case numComments = "num_comments"
    }
    
    func changeVisited(visited: Bool) {
        self.visited = visited
    }
}
