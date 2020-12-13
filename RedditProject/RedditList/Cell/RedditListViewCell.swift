//
//  RedditListView.swift
//  RedditProject
//
//  Created by Ivan Bober on 08/12/2020.
//

import UIKit
import SDWebImage
import RxSwift

class RedditListViewCell: UITableViewCell {
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var unreadStatusView: UIView!
    @IBOutlet weak var containerTitleDateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var commentsLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    static let identifier = "RedditListViewCell"
    
    func configureCell() {
        setStyle()
        prepareContainerTitleDateView()
        prepareAuthorLabel()
        prepareUnreadStatusView()
        prepareDateLabel()
        prepareTitleLabel()
        preparePostImage()
        prepareDismissButton()
        prepareCommentsLabel()
    }
    
    func bindViewModel(viewModel: RedditListCellViewModel) {
        authorLabel.text = viewModel.author
        unreadStatusView.isHidden = viewModel.visited
        dateLabel.text = "\(viewModel.date)"
        titleLabel.text = viewModel.title
        postImage.sd_setImage(with: viewModel.thumbURL, completed: nil)
        dismissButton.setTitle(viewModel.dismissButtonTitle, for: .normal)
        commentsLabel.text = viewModel.numComments
    }
    
    func visitedCell() {
        unreadStatusView.isHidden = true
        titleLabel.textColor = .lightGray
        dateLabel.textColor = .lightGray
        authorLabel.textColor = .lightGray
    }
}

private extension RedditListViewCell {
    func setStyle() {
        let image = UIImage(systemName: "chevron.right")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let accessoryImageView = UIImageView(image: image)
        accessoryView = accessoryImageView
        accessoryView?.backgroundColor = .black

        contentView.backgroundColor = .black
        backgroundColor = .black
        selectionStyle = .none
    }
    
    func prepareContainerTitleDateView() {
        containerTitleDateView.backgroundColor = .clear
    }
    
    func prepareAuthorLabel() {
        authorLabel.textColor = .white
        authorLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        authorLabel.textAlignment = .left
    }
    
    func prepareUnreadStatusView() {
        unreadStatusView.backgroundColor = .blue
        unreadStatusView.layer.cornerRadius = unreadStatusView.frame.height / 2
    }
    
    func prepareDateLabel() {
        dateLabel.textColor = .white
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        dateLabel.textAlignment = .left
    }

    func prepareTitleLabel() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.textAlignment = .left
    }
    
    func preparePostImage() {
        postImage.contentMode = .scaleAspectFit
    }
    
    func prepareDismissButton() {
        let image = UIImage(systemName: "xmark.circle")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        dismissButton.setImage(image, for: .normal)
        dismissButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        dismissButton.setTitleColor(.white, for: .normal)
        dismissButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    func prepareCommentsLabel() {
        commentsLabel.textColor = .orange
        commentsLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        commentsLabel.textAlignment = .right
    }
}
