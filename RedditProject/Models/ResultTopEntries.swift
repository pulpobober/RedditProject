//
//  ResultTopEntries.swift
//  RedditProject
//
//  Created by Ivan Bober on 08/12/2020.
//

import Foundation

struct ResultTopEntries: Codable {
    let data: RedditEntrie
    let kind: String
}

struct RedditResponse: Codable {
    let after: String?
    let before: String?
    let children: [ResultTopEntries]
}
