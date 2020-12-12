//
//  TableView+Extension.swift
//  RedditProject
//
//  Created by Ivan Bober on 12/12/2020.
//

import UIKit

extension UITableView {
    
    func getAllIndexPathInSection(section: Int) -> [IndexPath]? {
        let numberOfRows = self.numberOfRows(inSection: section)
        let indexPaths = (0..<numberOfRows).map { IndexPath(row: $0, section: 0) }
        return indexPaths
    }
}
