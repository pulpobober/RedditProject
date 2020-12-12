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
    
    @discardableResult mutating func removeAt(safeIndex: Int) -> Element? {
        guard self[safe: safeIndex] != nil else {
            return nil
        }
        return remove(at: safeIndex)
    }
}
