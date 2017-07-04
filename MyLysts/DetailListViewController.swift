//
//  DetailListViewController.swift
//  MyLysts
//
//  Created by keith martin on 7/3/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import UIKit
import Kingfisher
import Whisper

class DetailListViewController: UIViewController, UIScrollViewDelegate {
    
    private let list: ListItem
    private var headerView: UIView!
    private let tableView: UITableView
    private let currentUserOwns: Bool
    fileprivate var listItems: [DetailListItem] = []
    private let viewModel: DetailListViewModel
    private var canLoadMore: Bool = false
    private var footerView: UIView!
    private let footerActivityIndicator: UIActivityIndicatorView
    fileprivate let loadingActivityIndicator: UIActivityIndicatorView
    let refreshControl: UIRefreshControl

    init(currentUserOwns: Bool, list: ListItem) {
        self.list = list
        self.currentUserOwns = currentUserOwns
        self.tableView = UITableView(frame: .zero, style: .plain)
        viewModel = DetailListViewModel()
        footerActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createUI() {
        view.backgroundColor = Color.white
        
        setBarButtonItems()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Color.white
        tableView.register(ListItemTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        loadingActivityIndicator.hidesWhenStopped = true
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        footerActivityIndicator.hidesWhenStopped = true
        footerView.addSubview(footerActivityIndicator)
        
        setupHeaderView()
        addConstraints()
        fetchLists()
    }
    
    func setBarButtonItems() {
        let _ = navigationController?.navigationBar.subviews.map({ view in
            if view.tag == 1 {
                view.isHidden = true
            }
        })
        let navBarHeight = navigationController!.navigationBar.frame.height
        let buttonLeftMenu: UIButton = UIButton()
        buttonLeftMenu.setImage(UIImage(named: "back"), for: UIControlState())
        buttonLeftMenu.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        buttonLeftMenu.frame = CGRect(x: 0, y: 0, width: navBarHeight/2, height: navBarHeight/2)
        let barButton = UIBarButtonItem(customView: buttonLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
        
        if currentUserOwns {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editListTapped))
            self.navigationItem.rightBarButtonItem?.tintColor = Color.black
        }
    }
    
    func setupHeaderView() {
        headerView = UIView()
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = TextFont.headingMedium
        titleLabel.textColor = Color.black
        titleLabel.text = list.title
        titleLabel.textAlignment = .left
        let titleLabelHeight = titleLabel.requiredHeight(view.frame.width - 40)
        headerView.addSubview(titleLabel)
        
        let descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.font = TextFont.descriptionNormal
        descriptionLabel.textColor = Color.grey
        descriptionLabel.text = list.description
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        let descriptionLabelHeight = descriptionLabel.requiredHeight(view.frame.width - 40)
        headerView.addSubview(descriptionLabel)
        
        if let imageUrlString = list.imageURL, !imageUrlString.isEmpty {
            let imageView = UIImageView(frame: .zero)
            let imageViewHeight = (view.frame.width - 40) / 2
            let headerViewHeight = (titleLabelHeight + 40) + (descriptionLabelHeight + 20) + (imageViewHeight + 40)
            headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerViewHeight)
            imageView.kf.setImage(with: URL(string: imageUrlString))
            headerView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor.constraint(equalToConstant: imageViewHeight).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: (view.frame.width - 40)).isActive = true
            imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
            imageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20).isActive = true
        } else {
            headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (titleLabelHeight + 40) + (descriptionLabelHeight + 20))
        }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -20).isActive = true

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        descriptionLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: descriptionLabelHeight).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        
        tableView.tableHeaderView = headerView
    }
    
    func addConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        footerActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        footerActivityIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        footerActivityIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        footerActivityIndicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        footerActivityIndicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
    }
    
    func fetchLists() {
        viewModel.fetchDetailList(id: list.id) { (listItems, error, canLoadMore) in
            if error == nil {
                self.listItems = listItems!
                self.canLoadMore = canLoadMore
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                    self.loadingActivityIndicator.stopAnimating()
                }
            } else {
                DispatchQueue.main.async {
                    let errorMessage = Murmur(title: "Could not load lists", backgroundColor: UIColor.red, titleColor: Color.white, font: TextFont.descriptionSmall, action: nil)
                    Whisper.show(whistle: errorMessage, action: .show(2.0))
                    self.refreshControl.endRefreshing()
                    self.loadingActivityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func fetchMoreLists() {
        viewModel.fetchDetailList(loadMore: true, id: list.id) { (listItems, error, canLoadMore) in
            self.canLoadMore = canLoadMore
            guard error == nil else {
                DispatchQueue.main.async {
                    let errorMessage = Murmur(title: "Could not load more lists", backgroundColor: UIColor.red, titleColor: Color.white, font: TextFont.descriptionSmall, action: nil)
                    Whisper.show(whistle: errorMessage, action: .show(2.0))
                    self.tableView.tableFooterView = nil
                }
                return
            }
            let startIndex = self.listItems.count
            self.listItems.append(contentsOf: listItems!)
            let indexPaths = self.listItems[startIndex..<self.listItems.count].enumerated().map({ index,_ -> IndexPath in
                return IndexPath(row: (index + startIndex), section: 0)
            })
            self.insertRows(indexPaths: indexPaths)
        }
    }
    
    func deleteListItem(listId: String, listItemId: String) {
        viewModel.deleteListItem(listId: listId, listItemId: listItemId) { error in
            guard error == nil else {
                let errorMessage = Murmur(title: "Could not delete list item", backgroundColor: UIColor.red, titleColor: Color.white, font: TextFont.descriptionSmall, action: nil)
                Whisper.show(whistle: errorMessage, action: .show(2.0))
                DispatchQueue.main.async {
                    self.loadingActivityIndicator.stopAnimating()
                }
                return
            }
            DispatchQueue.main.async {
                self.loadingActivityIndicator.stopAnimating()
            }
        }
    }
    
    func insertRows(indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.tableView.insertRows(at: indexPaths, with: .bottom)
            self.tableView.tableFooterView = nil
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if distance < 200 && canLoadMore {
            tableView.tableFooterView = footerView
            footerActivityIndicator.startAnimating()
            fetchMoreLists()
        }
    }
    
    func editListTapped(sender: UIBarButtonItem) {
        let newListVC = NewListViewController(list: list)
        present(newListVC, animated: true, completion: nil)
        newListVC.didDismiss = { deleted in
            if deleted {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.listItems.removeAll()
                self.reloadData()
                self.fetchLists()
            }
        }
    }
    
    func refresh() {
        DispatchQueue.main.async {
            self.refreshControl.beginRefreshing()
        }
        fetchLists()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func backButtonTapped(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

}

extension DetailListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard listItems.isEmpty else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            return 1
        }
        tableView.separatorStyle = .none
        loadingActivityIndicator.startAnimating()
        tableView.backgroundView = loadingActivityIndicator
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListItemTableViewCell
        cell.updateCell(listItem: listItems[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        UIButton.appearance().setTitleColor(UIColor.black, for: UIControlState.normal)
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "✕") { (action, indexPath) in
            let listItem = self.listItems[indexPath.row]
            self.deleteListItem(listId: listItem.listId, listItemId: listItem.id)
            self.listItems.remove(at: indexPath.row)
            DispatchQueue.main.async(execute: {
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
        }
        
        deleteAction.backgroundColor = UIColor.white
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = listItems[indexPath.row].url
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

        webView.loadRequest(URLRequest(url: URL(string: urlString)!))
        navigationController?.pushViewController(WebViewController(webView: webView), animated: true)
    }
}
