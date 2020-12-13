//
//  SplitViewDelegate.swift
//  RedditProject
//
//  Created by Ivan Bober on 12/12/2020.
//

import UIKit

class SplitViewDelegate: UISplitViewControllerDelegate {
    
    //TODO Verify this variables
//    func splitViewController(_ svc: UISplitViewController, willShow vc: UIViewController, invalidating barButtonItem: UIBarButtonItem) {
//        if let detailView = svc.viewControllers.first as? UINavigationController {
//            svc.navigationItem.backBarButtonItem = nil
//            detailView.topViewController?.navigationItem.leftBarButtonItem = nil
//        }
//    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        return true
        //TODO Verify this variables
        /*
        guard let navigationController = primaryViewController as? UINavigationController,
              let controller = navigationController.topViewController as? RedditListViewController
        else {
            return true
        }
        
        return controller.collapseDetailViewController
 */
    }
    
    @available(iOS 14.0, *)
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}
