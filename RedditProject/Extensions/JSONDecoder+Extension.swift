//
//  JSONDecoder+Extension.swift
//  RedditProject
//
//  Created by Ivan Bober on 08/12/2020.
//

import Foundation

extension JSONDecoder {
    
    public static var redditDecoder: JSONDecoder {
        let decoder = JSONDecoder()
//        let dateFormatter = SomeDateFormatter
//        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
}
