//
//  NewListViewController.swift
//  MyLysts
//
//  Created by keith martin on 7/2/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import UIKit
import Whisper

class NewListViewController: UIViewController {
    
    private let viewModel: NewListViewModel
    private let closeButton: UIButton
    private let createButton: UIButton
    private let tableView: UITableView
    fileprivate var listItems: [[String: String]] = []
    private var headerView: UIView!
    private let listTitleTextField: UITextField
    private let listDescriptionTextField: UITextField
    private let listImageUrlTextField: UITextField
    private var footerView: UIView!
    private let addListItemButton: UIButton
    private let activityIndicatorView: UIActivityIndicatorView
    private let publicListButton: UIButton
    private let unlistedListButton: UIButton
    private let privateListButton: UIButton
    private let deleteListButton: UIButton
    private var currentListId: String = ""
    var didDismiss: ((_ deleted: Bool) -> ())?
    fileprivate var list: ListItem?
    
    init(list: ListItem? = nil) {
        viewModel = NewListViewModel()
        closeButton = UIButton(frame: .zero)
        createButton = UIButton(frame: .zero)
        tableView = UITableView(frame: .zero, style: .plain)
        listTitleTextField = UITextField(frame: .zero)
        listDescriptionTextField = UITextField(frame: .zero)
        listImageUrlTextField = UITextField(frame: .zero)
        addListItemButton = UIButton(frame: .zero)
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        publicListButton = UIButton(frame: .zero)
        unlistedListButton = UIButton(frame: .zero)
        privateListButton = UIButton(frame: .zero)
        deleteListButton = UIButton(frame: .zero)
        self.list = list
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        createUI()
        if let _ = list {
            setupList()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
            if !listItems.isEmpty {
                tableView.scrollToRow(at: IndexPath(row: listItems.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createUI() {
        view.backgroundColor = Color.white
        
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        
        createButton.setTitle("Save", for: .normal)
        createButton.setTitleColor(Color.lightBlack, for: .normal)
        createButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(createButton)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Color.white
        tableView.register(NewListItemTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.keyboardDismissMode = .onDrag
        view.addSubview(tableView)
        
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 270))
        headerView.backgroundColor = Color.white
        tableView.tableHeaderView = headerView
        
        listTitleTextField.setBottomBorder()
        listTitleTextField.attributedPlaceholder = NSAttributedString(string: "List Title", attributes: [NSForegroundColorAttributeName : Color.lightGrey])
        headerView.addSubview(listTitleTextField)
        
        listDescriptionTextField.setBottomBorder()
        listDescriptionTextField.attributedPlaceholder = NSAttributedString(string: "List Description", attributes: [NSForegroundColorAttributeName : Color.lightGrey])
        headerView.addSubview(listDescriptionTextField)
        
        listImageUrlTextField.setBottomBorder()
        listImageUrlTextField.attributedPlaceholder = NSAttributedString(string: "List Image Url - e.g. coolwebsite.com/image.png", attributes: [NSForegroundColorAttributeName : Color.lightGrey])
        headerView.addSubview(listImageUrlTextField)
        
        if let _ = list {
            createDeleteButton()
        } else {
            createButtons()
        }
        
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        footerView.backgroundColor = Color.white
        tableView.tableFooterView = footerView
        
        addListItemButton.setImage(UIImage(named: "add"), for: .normal)
        addListItemButton.addTarget(self, action: #selector(addListItemButtonTapped), for: .touchUpInside)
        footerView.addSubview(addListItemButton)
        
        activityIndicatorView.hidesWhenStopped = true
        footerView.addSubview(activityIndicatorView)

        addConstraints()
    }
    
    func createButtons() {
        publicListButton.createOvalButton()
        publicListButton.backgroundColor = Color.white
        publicListButton.setTitleColor(Color.lightGrey, for: .normal)
        publicListButton.setTitleColor(Color.green, for: .selected)
        publicListButton.layer.borderColor = Color.lightGrey.cgColor
        publicListButton.setTitle("Public", for: .normal)
        publicListButton.isSelected = true
        publicListButton.addTarget(self, action: #selector(listPrivacyButtonTapped), for: .touchUpInside)
        headerView.addSubview(publicListButton)
        
        unlistedListButton.createOvalButton()
        unlistedListButton.backgroundColor = Color.white
        unlistedListButton.setTitleColor(Color.lightGrey, for: .normal)
        unlistedListButton.setTitleColor(Color.green, for: .selected)
        unlistedListButton.layer.borderColor = Color.lightGrey.cgColor
        unlistedListButton.setTitle("Unlisted", for: .normal)
        unlistedListButton.addTarget(self, action: #selector(listPrivacyButtonTapped), for: .touchUpInside)
        headerView.addSubview(unlistedListButton)
        
        privateListButton.createOvalButton()
        privateListButton.backgroundColor = Color.white
        privateListButton.setTitleColor(Color.lightGrey, for: .normal)
        privateListButton.setTitleColor(Color.green, for: .selected)
        privateListButton.layer.borderColor = Color.lightGrey.cgColor
        privateListButton.setTitle("Private", for: .normal)
        privateListButton.addTarget(self, action: #selector(listPrivacyButtonTapped), for: .touchUpInside)
        headerView.addSubview(privateListButton)
        
        addButtonConstraints()
    }
    
    func createDeleteButton() {
        deleteListButton.createOvalButton()
        deleteListButton.backgroundColor = Color.white
        deleteListButton.setTitleColor(UIColor.red, for: .normal)
        deleteListButton.layer.borderColor = Color.lightGrey.cgColor
        deleteListButton.setTitle("Delete", for: .normal)
        deleteListButton.addTarget(self, action: #selector(deleteListButtonTapped), for: .touchUpInside)
        headerView.addSubview(deleteListButton)
        
        addDeleteButtonConstraints()
    }
    
    func addConstraints() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor).isActive = true
        createButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        tableView.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        listTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        listTitleTextField.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20).isActive = true
        listTitleTextField.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20).isActive = true
        listTitleTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        listTitleTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        listDescriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        listDescriptionTextField.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20).isActive = true
        listDescriptionTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        listDescriptionTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        listDescriptionTextField.topAnchor.constraint(equalTo: listTitleTextField.bottomAnchor, constant: 20).isActive = true
        
        listImageUrlTextField.translatesAutoresizingMaskIntoConstraints = false
        listImageUrlTextField.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20).isActive = true
        listImageUrlTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        listImageUrlTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        listImageUrlTextField.topAnchor.constraint(equalTo: listDescriptionTextField.bottomAnchor, constant: 20).isActive = true
        
        addListItemButton.translatesAutoresizingMaskIntoConstraints = false
        addListItemButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addListItemButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addListItemButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        addListItemButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
    }
    
    func addButtonConstraints() {
        let buttonWidth = (view.frame.width - 60)/3
        publicListButton.translatesAutoresizingMaskIntoConstraints = false
        publicListButton.topAnchor.constraint(equalTo: listImageUrlTextField.bottomAnchor, constant: 20).isActive = true
        publicListButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        publicListButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        publicListButton.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20).isActive = true
        
        unlistedListButton.translatesAutoresizingMaskIntoConstraints = false
        unlistedListButton.centerYAnchor.constraint(equalTo: publicListButton.centerYAnchor).isActive = true
        unlistedListButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        unlistedListButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        unlistedListButton.leftAnchor.constraint(equalTo: publicListButton.rightAnchor, constant: 10).isActive = true
        
        privateListButton.translatesAutoresizingMaskIntoConstraints = false
        privateListButton.centerYAnchor.constraint(equalTo: publicListButton.centerYAnchor).isActive = true
        privateListButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        privateListButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        privateListButton.leftAnchor.constraint(equalTo: unlistedListButton.rightAnchor, constant: 10).isActive = true
    }
    
    func addDeleteButtonConstraints() {
        deleteListButton.translatesAutoresizingMaskIntoConstraints = false
        deleteListButton.topAnchor.constraint(equalTo: listImageUrlTextField.bottomAnchor, constant: 20).isActive = true
        deleteListButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        deleteListButton.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        deleteListButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
    }
    
    func addListItemButtonTapped(sender: UIButton) {
        if !listItems.isEmpty {
            guard isValidListItem() else {return}
            let cell = tableView.cellForRow(at: IndexPath(row: listItems.count - 1, section: 0)) as! NewListItemTableViewCell
            let listItemInfo = ["type":"link","title": cell.getTitleText(),"description": cell.getDescriptionText(),"url": cell.getUrlText(),"imageUrl": cell.getImageUrlText()]
            addListItem(save: false, listItemInfo: listItemInfo)
        } else {
            guard isValidList() else {return}
            let listInfo = ["title": listTitleTextField.text!, "description": listDescriptionTextField.text!, "imageUrl": listImageUrlTextField.text ?? "", "privacy": selectedPrivacy()]
            createNewList(save: false, listInfo: listInfo)
        }
    }
    
    func saveList() -> Bool {
        if !listItems.isEmpty {
            guard isValidListItem() else {return false}
            let cell = tableView.cellForRow(at: IndexPath(row: listItems.count - 1, section: 0)) as! NewListItemTableViewCell
            let listItemInfo = ["type":"link","title": cell.getTitleText(),"description": cell.getDescriptionText(),"url": cell.getUrlText(),"imageUrl": cell.getImageUrlText()]
            addListItem(save: true, listItemInfo: listItemInfo)
            return true
        } else {
            guard isValidList() else {return false}
            let listInfo = ["title": listTitleTextField.text!, "description": listDescriptionTextField.text!, "imageUrl": listImageUrlTextField.text ?? "", "privacy": selectedPrivacy()]
            createNewList(save: true, listInfo: listInfo)
            return true
        }
    }
    
    func setupList() {
        listTitleTextField.text = list!.title
        listDescriptionTextField.text = list!.description
        listTitleTextField.allowsEditingTextAttributes = false
        listDescriptionTextField.allowsEditingTextAttributes = false
        listItems.append(["":""])
    }
    
    func createNewList(save: Bool, listInfo: [String: String]) {
        addListItemButton.isHidden = true
        activityIndicatorView.startAnimating()
        viewModel.createNewList(listInfo: listInfo) { (newListDict, error) in
            if error == nil, let newList = newListDict as? JSONDictionary {
                self.currentListId = newList["id"] as! String
                if !save {
                    DispatchQueue.main.async {
                        self.activityIndicatorView.stopAnimating()
                        self.addListItemButton.isHidden = false
                        self.listItems.append(["":""])
                        self.tableView.insertRows(at: [IndexPath(row: self.listItems.count - 1, section: 0)], with: .top)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let errorMessage = Murmur(title: "Could not create a new list", backgroundColor: UIColor.red, titleColor: Color.white, font: TextFont.descriptionSmall, action: nil)
                    Whisper.show(whistle: errorMessage, action: .show(2.0))
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }
    }
    
    func addListItem(save: Bool, listItemInfo: [String: String]) {
        addListItemButton.isHidden = true
        activityIndicatorView.startAnimating()
        let listId: String!
        if let _ = list {
            listId = list?.id
        } else {
            listId = currentListId
        }
        viewModel.addListItem(listId: listId, listItemInfo: listItemInfo) { (_, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.addListItemButton.isHidden = false
                    self.listItems[self.listItems.count - 1] = listItemInfo
                    self.listItems.append(["":""])
                    self.tableView.insertRows(at: [IndexPath(row: self.listItems.count - 1, section: 0)], with: .top)
                }
                
            } else {
                DispatchQueue.main.async {
                    let errorMessage = Murmur(title: "Could not add list item", backgroundColor: UIColor.red, titleColor: Color.white, font: TextFont.descriptionSmall, action: nil)
                    Whisper.show(whistle: errorMessage, action: .show(2.0))
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }
    }
    
    func closeButtonTapped(sender: UIButton) {
        if !currentListId.isEmpty {
            viewModel.deleteList(listId: currentListId)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func saveButtonTapped(sender: UIButton) {
        guard saveList() else {return}
        didDismiss?(false)
        dismiss(animated: true, completion: nil)
    }
    
    func isValidList() -> Bool {
        guard let listTitle = listTitleTextField.text, !listTitle.isEmpty else {
            let message: String = "Your list must have a title that's four letters long"
            let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        guard let listDescription = listDescriptionTextField.text, !listDescription.isEmpty else {
            let message: String = "Your list must have a description"
            let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func isValidListItem() -> Bool {
        let cell = tableView.cellForRow(at: IndexPath(row: listItems.count - 1, section: 0)) as! NewListItemTableViewCell
        guard cell.getUrlText().isEmpty, !cell.getUrlText().isValidUrl() else {return true}
        let alert = UIAlertController(title: nil, message: "You must have a valid url in a list item", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return false
    }
    
    func selectedPrivacy() -> String {
        guard !publicListButton.isSelected else {return "public"}
        guard !unlistedListButton.isSelected else {return "unlisted"}
        return "private"
    }
    
    func listPrivacyButtonTapped(sender: UIButton) {
        switch sender.titleLabel!.text! {
        case "Public":
            publicListButton.isSelected = true
            unlistedListButton.isSelected = false
            privateListButton.isSelected = false
        case "Unlisted":
            unlistedListButton.isSelected = true
            publicListButton.isSelected = false
            privateListButton.isSelected = false
        case "Private":
            privateListButton.isSelected = true
            publicListButton.isSelected = false
            unlistedListButton.isSelected = false
        default:
            return
        }
    }
    
    func deleteListButtonTapped(sender: UIButton) {
        viewModel.deleteList(listId: list!.id)
        didDismiss?(true)
        dismiss(animated: true, completion: nil)
    }
    
    func setSelected(privacy: String) {
        switch privacy {
        case "public":
            publicListButton.isSelected = true
            unlistedListButton.isSelected = false
            privateListButton.isSelected = false
        case "unlisted":
            unlistedListButton.isSelected = true
            publicListButton.isSelected = false
            privateListButton.isSelected = false
        case "private":
            privateListButton.isSelected = true
            publicListButton.isSelected = false
            unlistedListButton.isSelected = false
        default:
            return
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension NewListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NewListItemTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
}
