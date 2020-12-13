//
//  UITableView+Extension.swift
//  RedditProject
//
//  Created by Ivan Bober on 13/12/2020.
//

import UIKit
import RxSwift

extension UITableView {
    func showBottomSpinner() {
        let spinner = UIActivityIndicatorView(style: .white)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.bounds.width, height: CGFloat(44))
        self.tableFooterView = spinner
        self.tableFooterView?.isHidden = false
    }
}
