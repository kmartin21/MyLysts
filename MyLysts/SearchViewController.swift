//
//  SearchViewController.swift
//  MyLysts
//
//  Created by keith martin on 7/4/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation
import UIKit
import Whisper

class SearchViewController: UITableViewController, UISearchBarDelegate {
    var filteredTableData = [ListItem]()
    var resultSearchController = UISearchController(searchResultsController: nil)
    var selectedList: ((ListItem) -> Void)?
    private let viewModel: SearchViewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.placeholder = "Search lists"
        resultSearchController.searchBar.delegate = self
        
        resultSearchController.searchBar.barTintColor = UIColor(red: 236, green: 240, blue: 241)
        resultSearchController.searchBar.tintColor = UIColor(red: 102, green: 102, blue: 102)
        resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = resultSearchController.searchBar
        
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.register(ListItemTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.resultSearchController.searchBar.becomeFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTableData.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.numberOfRows(inSection: 0) > 0 else {
            return
        }
        let listItem = filteredTableData[indexPath.row]
        dismiss(animated: true) { 
            self.selectedList?(listItem)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListItemTableViewCell
        let listItem = filteredTableData[indexPath.row]
        cell.updateCell(listItem: listItem)
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(search), object: nil)
        self.perform(#selector(search), with: nil, afterDelay: 0.5)
    }
    
    func search() {
        let keyword = resultSearchController.searchBar.text!
        guard !keyword.isEmpty else {
            filteredTableData.removeAll()
            DispatchQueue.main.async(execute: {
                self.tableView.separatorStyle = .none
                self.tableView.reloadData()
            })
            return
        }
        viewModel.searchLists(keyword: keyword) { (listItems, error) in
            if let listItems = listItems, error == nil {
            self.filteredTableData = listItems
                DispatchQueue.main.async {
                    if !self.filteredTableData.isEmpty {
                        self.tableView.separatorStyle = .singleLine
                    }
                    self.tableView.reloadData()
                }
                return
            } else {
                DispatchQueue.main.async {
                    let errorMessage = Murmur(title: "Could not search keyword", backgroundColor: UIColor.red, titleColor: Color.white, font: TextFont.descriptionSmall, action: nil)
                    Whisper.show(whistle: errorMessage, action: .show(2.0))
                }
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

