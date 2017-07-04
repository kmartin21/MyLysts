//
//  Test2ViewController.swift
//  MyLysts
//
//  Created by keith martin on 6/27/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import UIKit
import Whisper

class UserListsViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let viewModel: UserListsViewModel
    private let tableView: UITableView
    private var footerView: UIView!
    private let activityIndicator: UIActivityIndicatorView
    private let refreshControl: UIRefreshControl
    fileprivate var userLists: [ListItem] = []
    private var canLoadMore: Bool!
    fileprivate var emptyUserListsTableView: EmptyUserListsTableView!
    
    init() {
        viewModel = UserListsViewModel()
        tableView = UITableView(frame: .zero, style: .plain)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        refreshControl = UIRefreshControl(frame: .zero)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createUI() {
        view.backgroundColor = Color.white
        
        navigationController?.navigationBar.isHidden = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Color.white
        tableView.register(ListItemTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        activityIndicator.hidesWhenStopped = true
        footerView.addSubview(activityIndicator)
        
        emptyUserListsTableView = EmptyUserListsTableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        emptyUserListsTableView.getCreateListButton().addTarget(self, action: #selector(createListButtonTapped), for: .touchUpInside)
                
        refreshList()
        addConstraints()
    }
    
    func addConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
    }
    
    func refresh(sender: UIRefreshControl) {
        fetchUserLists()
    }
    
    func refreshList() {
        refreshControl.beginRefreshing()
        fetchUserLists()
    }
    
    func fetchUserLists() {
        let errorMessage = Murmur(title: "Could not load lists", backgroundColor: UIColor.red, titleColor: Color.white, font: TextFont.descriptionSmall, action: nil)
        viewModel.fetchCurrentUserLists(loadMore: false) { (listItems, error, canLoadMore) in
            self.canLoadMore = canLoadMore
            guard error == nil else {
                DispatchQueue.main.async {
                    Whisper.show(whistle: errorMessage, action: .show(2.0))
                    self.refreshControl.endRefreshing()
                }
                return
            }
            guard let listItems = listItems else {
                self.refreshControl.endRefreshing()
                return
            }
            self.userLists = listItems
            self.reloadData()
        }
    }
    
    func loadMoreUserLists() {
        let errorMessage = Murmur(title: "Could not load more lists", backgroundColor: UIColor.red, titleColor: Color.white, font: TextFont.descriptionSmall, action: nil)
        viewModel.fetchCurrentUserLists(loadMore: true) { (listItems, error, canLoadMore) in
            self.canLoadMore = canLoadMore
            guard error == nil else {
                DispatchQueue.main.async {
                    Whisper.show(whistle: errorMessage, action: .show(2.0))
                    self.refreshControl.endRefreshing()
                }
                return
            }
            guard let listItems = listItems else {
                self.refreshControl.endRefreshing()
                return
            }
            let startIndex = self.userLists.count
            self.userLists.append(contentsOf: listItems)
            let indexPaths = self.userLists[startIndex..<self.userLists.count].enumerated().map({ index,_ -> IndexPath in
                return IndexPath(row: (index + startIndex), section: 0)
            })
            self.insertRows(indexPaths: indexPaths)
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func insertRows(indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.tableView.insertRows(at: indexPaths, with: .bottom)
            self.activityIndicator.stopAnimating()
            self.tableView.tableFooterView = nil
        }
    }
    
    func createListButtonTapped(sender: UIButton) {
        let newListVC = NewListViewController()
        self.present(NewListViewController(), animated: true, completion: nil)
        newListVC.didDismiss = { _ in
            self.refreshList()
        }
    }
    
    func logoutButtonTapped(sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        
        let loginViewController = LoginViewController()
        self.navigationController?.setViewControllers([loginViewController], animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if distance < 200 && canLoadMore {
            tableView.tableFooterView = footerView
            activityIndicator.startAnimating()
            loadMoreUserLists()
        }
    }
}

extension UserListsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard userLists.isEmpty else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            return 1
        }
        tableView.separatorStyle = .none
        tableView.backgroundView = emptyUserListsTableView
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListItemTableViewCell
        cell.updateCell(privacy: true, listItem: userLists[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = userLists[indexPath.row]
        let detailListVC = DetailListViewController(currentUserOwns: list.currentUserOwns, list: list)
        navigationController?.pushViewController(detailListVC, animated: true)
    }
}
