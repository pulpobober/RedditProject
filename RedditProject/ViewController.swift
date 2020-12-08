//
//  ViewController.swift
//  RedditProject
//
//  Created by Ivan Bober on 07/12/2020.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkRepository.requestToken()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            NetworkRepository.loadJSON()
        }
    }
}
