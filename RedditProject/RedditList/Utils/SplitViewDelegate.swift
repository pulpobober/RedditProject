//
//  SplitViewDelegate.swift
//  RedditProject
//
//  Created by Ivan Bober on 12/12/2020.
//

import UIKit

class SplitViewDelegate: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        return true
    }
    
    @available(iOS 14.0, *)
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}
