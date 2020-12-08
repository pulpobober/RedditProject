//
//  Bundle+Extension.swift
//  RedditProject
//
//  Created by Ivan Bober on 08/12/2020.
//

import Foundation

extension Bundle {
    class func infoValueInMainBundle(for key: String) -> AnyObject? {
        if let obj = self.main.localizedInfoDictionary?[key] {
            return obj as AnyObject
        }
        if let obj = self.main.infoDictionary?[key] {
            return obj as AnyObject
        }
        return nil
    }
}
