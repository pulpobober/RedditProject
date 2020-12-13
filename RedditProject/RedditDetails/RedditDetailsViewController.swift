//
//  RedditDetailsViewController.swift
//  RedditProject
//
//  Created by Ivan Bober on 13/12/2020.
//

import UIKit
import RxSwift

class RedditDetailsViewController: UIViewController {
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private let _disposeBag = DisposeBag()
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
        
        postImage
            .tapped()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let imageUrl = viewModel.fullImageUrl,
                      let imageData = try? Data(contentsOf: imageUrl),
                      let image = UIImage(data: imageData) else {
                    return
                }
                
                self?.showSavePhotoAlert(image: image)
                                
            })
            .disposed(by: _disposeBag)
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
        postImage.isUserInteractionEnabled = true
    }

    func hideViews(hide: Bool) {
        authorLabel.isHidden = hide
        postImage.isHidden = hide
        titleLabel.isHidden = hide
    }
    
    func showSavePhotoAlert(image: UIImage) {
        let alert = UIAlertController(title: "Save Photo in gallery", message: "Are you sure you want to save this photo in the phone library?", preferredStyle: UIAlertController.Style.alert)
            
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            self.savePhotoInPhoneLibrary(image: image)
        }))
            
        self.present(alert, animated: true, completion: .none)
    }
    
    func savePhotoInPhoneLibrary(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            showSuccessAlert()
        }
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Save Photo in gallery", message: "The image was perfectly stored", preferredStyle: UIAlertController.Style.alert)
            
        alert.addAction(UIAlertAction(title: "Understood!", style: .cancel))
            
        self.present(alert, animated: true, completion: .none)

    }
}
