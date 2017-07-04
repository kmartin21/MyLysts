//
//  DetailListViewController.swift
//  MyLysts
//
//  Created by keith martin on 7/3/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import UIKit
import Kingfisher

class DetailListViewController: UIViewController, UIScrollViewDelegate {
    
    private let list: List
    private var headerView: UIView!
    private let tableView: UITableView
    fileprivate var listItems: [DetailListItem] = []
    private let viewModel: DetailListViewModel
    private var canLoadMore: Bool = false
    private var footerView: UIView!
    private let footerActivityIndicator: UIActivityIndicatorView
    fileprivate let loadingActivityIndicator: UIActivityIndicatorView

    init(listId: String, title: String, description: String, imageUrl: String) {
        self.list = List(id: listId, title: title, description: description, imageUrl: imageUrl)
        self.tableView = UITableView(frame: .zero, style: .plain)
        viewModel = DetailListViewModel()
        footerActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
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
        
        
        
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Color.white
        tableView.register(ListItemTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        footerActivityIndicator.hidesWhenStopped = true
        footerView.addSubview(footerActivityIndicator)
        
        setupHeaderView()
        addConstraints()
        fetchLists()
    }
    
    func setupHeaderView() {
        headerView = UIView()
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = TextFont.headingMedium
        titleLabel.textColor = Color.black
        titleLabel.text = list.title
        titleLabel.textAlignment = .left
        headerView.addSubview(titleLabel)
        
        let descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.font = TextFont.descriptionNormal
        descriptionLabel.textColor = Color.grey
        descriptionLabel.text = list.description
        descriptionLabel.textAlignment = .left
        headerView.addSubview(descriptionLabel)
        
        if !list.imageUrl.isEmpty {
            let imageView = UIImageView(frame: .zero)
            headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 280)
            imageView.kf.setImage(with: URL(string: list.imageUrl))
            headerView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor.constraint(equalToConstant: (view.frame.width - 40) / 2).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
            imageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20).isActive = true
        } else {
            headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -20).isActive = true

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -20).isActive = true
        
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
            self.listItems = listItems!
            self.canLoadMore = canLoadMore
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if distance < 200 && canLoadMore {
            tableView.tableFooterView = footerView
            footerActivityIndicator.startAnimating()
            fetchLists()
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListItemTableViewCell
        cell.updateCell(listItem: listItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
