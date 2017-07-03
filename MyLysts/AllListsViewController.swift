//
//  ViewController.swift
//  MyLysts
//
//  Created by keith martin on 6/22/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import UIKit

class AllListsViewController: UIViewController, UIScrollViewDelegate {
    
    private let viewModel: AllListsViewModel
    private let tableView: UITableView
    private var footerView: UIView!
    private let activityIndicator: UIActivityIndicatorView
    private let refreshControl: UIRefreshControl
    fileprivate var allLists: [ListItem] = []
    private var canLoadMore: Bool = false
    
    init() {
        viewModel = AllListsViewModel()
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
        
//        let logoutLabel = UIButton()
//        logoutLabel.setTitleColor(.black, for: .normal)
//        logoutLabel.setTitle("Logout", for: .normal)
//        logoutLabel.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
//        view.addSubview(logoutLabel)
//        
//        logoutLabel.translatesAutoresizingMaskIntoConstraints = false
//        logoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        logoutLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        activityIndicator.hidesWhenStopped = true
        footerView.addSubview(activityIndicator)
        
        addConstraints()
        refreshControl.beginRefreshing()
        fetchPublicLists()
    }
    
    
    func createTailLoadingIndicator() {
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
        fetchPublicLists()
    }
    
    func fetchPublicLists() {
        viewModel.fetchPublicLists(loadMore: false) { (listItems, error, canLoadMore) in
            self.canLoadMore = canLoadMore
            guard error == nil else {
                self.refreshControl.endRefreshing()
                return
            }
            guard let listItems = listItems else {
                self.refreshControl.endRefreshing()
                return
            }
            self.allLists = listItems
            self.reloadData()
        }
    }
    
    func loadMorePublicLists() {
        viewModel.fetchPublicLists(loadMore: true) { (listItems, error, canLoadMore) in
            self.canLoadMore = canLoadMore
            guard error == nil else {
                self.refreshControl.endRefreshing()
                return
            }
            guard let listItems = listItems else {
                self.refreshControl.endRefreshing()
                return
            }
            let startIndex = self.allLists.count
            self.allLists.append(contentsOf: listItems)
            let indexPaths = self.allLists[startIndex..<self.allLists.count].enumerated().map({ index,_ -> IndexPath in
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
            loadMorePublicLists()
        }
    }
}

extension AllListsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard allLists.isEmpty else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            return 1
        }
        tableView.separatorStyle = .none
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListItemTableViewCell
        cell.updateCell(listItem: allLists[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
