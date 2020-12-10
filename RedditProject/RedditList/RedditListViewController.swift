//
//  RedditListViewController.swift
//  RedditProject
//
//  Created by Ivan Bober on 07/12/2020.
//

import UIKit

import RxSwift
class RedditListViewController: UIViewController {
    private let _disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    private let _viewModel = RedditListViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        bindViewModel()
    }
    
    func bindView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .white
    }
    
    func bindViewModel() {
        _viewModel.reloadTable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: _disposeBag)
    }
}


extension RedditListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RedditListViewCell.identifier, for: indexPath) as? RedditListViewCell,
              let redditEntrie = _viewModel.getRedditEntrie(index: indexPath.row) else {
            return UITableViewCell()
        }
        
        let cellViewModel = RedditListCellViewModel(redditEntrie: redditEntrie)
        cell.configureCell()
        cell.bindViewModel(viewModel: cellViewModel)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
