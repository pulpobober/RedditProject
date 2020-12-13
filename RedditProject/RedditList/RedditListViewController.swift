//
//  RedditListViewController.swift
//  RedditProject
//
//  Created by Ivan Bober on 07/12/2020.
//

import UIKit
import RxSwift
import RxCocoa

class RedditListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dismissAllButton: UIButton!
    
    private let _disposeBag = DisposeBag()
    private let _viewModel = RedditListViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        bindViewModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let controller = (segue.destination as? UINavigationController)?.topViewController as? RedditDetailsViewController,
                  let indexPath = tableView.indexPathForSelectedRow,
                  let redditEntrie = _viewModel.getRedditEntrie(index: indexPath.row) else {
                return
            }
            
            let viewModel = _viewModel.getRedditDetailsViewModel(redditEntrie: redditEntrie)
            controller.viewModel = viewModel
        }
    }
}

private extension RedditListViewController {
    
    func bindView() {
        setStyle()
        prepareTableView()
        prepareNavigationBar()
        prepareDismissButton()
        
        dismissAllButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let tableView = self?.tableView,
                      let indexPaths = tableView.getAllIndexPathInSection(section: 0) else {
                    return
                }
                self?._viewModel.deleteAllPosts()
                tableView.deleteRows(at: indexPaths, with: .fade)
            })
            .disposed(by: _disposeBag)
    }
    
    func bindViewModel() {
        _viewModel.reloadTable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: _disposeBag)
    }
    func setStyle() {
        view.backgroundColor = .black
    }
    
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .white
        tableView.backgroundColor = .black
        tableView.tableFooterView = UIView()
    }
    
    func prepareNavigationBar() {
        guard let navigationBar = self.navigationController?.navigationBar else {
            return
        }
        
        navigationBar.barTintColor = .black
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.topItem?.title = _viewModel.titleNavigationBar
        navigationBar.barStyle = .black
    }
    
    func prepareDismissButton() {
        dismissAllButton.backgroundColor = .black
        dismissAllButton.setTitle(_viewModel.titleDismissAllButton, for: .normal)
        dismissAllButton.setTitleColor(.orange, for: .normal)
    }
    
    func bindCell(cell: RedditListViewCell) {
        cell.dismissButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let indexPath = self?.tableView.indexPath(for: cell) else {
                    return
                }
                
                self?._viewModel.deletePost(index: indexPath.row)
                self?.tableView.beginUpdates()
                self?.tableView.deleteRows(at: [indexPath], with: .left)
                self?.tableView.endUpdates()
            })
            .disposed(by: cell.disposeBag)
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
        bindCell(cell: cell)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: select cell and change blue icon
    }
    
}
