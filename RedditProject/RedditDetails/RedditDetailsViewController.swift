//
//  RedditDetailsViewController.swift
//  RedditProject
//
//  Created by Ivan Bober on 13/12/2020.
//

import UIKit

class RedditDetailsViewController: UIViewController {
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewModel: RedditDetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }
}

private extension RedditDetailsViewController {
    func bindView() {
        setStyle()
        prepareAuthorLabel()
        preparePostImage()
        prepareTitleLabel()
        
        guard let viewModel = viewModel else {
            hideViews(hide: true)
            return
        }
        hideViews(hide: false)
        authorLabel.text = viewModel.author
        postImage.sd_setImage(with: viewModel.thumbURL, completed: .none)
        titleLabel.text = viewModel.title
    }
    
    func setStyle() {
        view.backgroundColor = .white
    }
    
    func prepareAuthorLabel() {
        authorLabel.textColor = .black
        authorLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        authorLabel.textAlignment = .center
    }

    func prepareTitleLabel() {
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
    }
    
    func preparePostImage() {
        postImage.contentMode = .scaleAspectFit
    }

    func hideViews(hide: Bool) {
        authorLabel.isHidden = hide
        postImage.isHidden = hide
        titleLabel.isHidden = hide

    }
}
