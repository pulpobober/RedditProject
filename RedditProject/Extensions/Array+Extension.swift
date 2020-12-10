//
//  Array+Extension.swift
//  RedditProject
//
//  Created by Ivan Bober on 10/12/2020.
//

import Foundation

public extension Array {
    subscript (safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
}
