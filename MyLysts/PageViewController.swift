//
//  PageViewController.swift
//  MyLysts
//
//  Created by keith martin on 6/27/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import UIKit
import Kingfisher

class PageViewController: UIViewController, UIScrollViewDelegate, PageControlDelegate {
    
    private let pageControl: PageControl
    private var scrollView: UIScrollView
    private let newListButton: UIButton
    private let searchButton: UIButton
    private let profileImageButton: UIButton

    init() {
        pageControl = PageControl(titles: ["All", "Mine"])
        scrollView = UIScrollView()
        newListButton = UIButton(frame: .zero)
        searchButton = UIButton(frame: .zero)
        profileImageButton = UIButton(frame: .zero)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
        setViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func createUI() {
        view.backgroundColor = Color.white
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        view.addSubview(scrollView)

        newListButton.setImage(UIImage(named: "new_list"), for: .normal)
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        profileImageButton.kf.setImage(with: URL(string: User.currentUser!.profileImageUrl), for: .normal)
        profileImageButton.imageView?.contentMode = .scaleAspectFit
        profileImageButton.layer.cornerRadius = 0.5 * (navigationController!.navigationBar.frame.height/1.5)
        profileImageButton.clipsToBounds = true
        
        let navBar = navigationController?.navigationBar
        navBar?.addSubview(pageControl.stack!)
        navBar?.addSubview(newListButton)
        navBar?.addSubview(searchButton)
        navBar?.addSubview(profileImageButton)
        navBar?.barTintColor = Color.backgroundGrey
        navBar?.isTranslucent = false
        
        pageControl.delegate = self
        
        addConstraints()
    }
    
    func addConstraints() {
        let width = view.frame.width
        let height = view.frame.height
        let navBar = navigationController?.navigationBar
        
        scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        scrollView.contentSize = CGSize(width: width * 2, height: height)
        
        pageControl.stack?.heightAnchor.constraint(equalToConstant: navBar!.frame.height).isActive = true
        pageControl.stack?.leftAnchor.constraint(equalTo: navBar!.leftAnchor, constant: 10).isActive = true
        pageControl.stack?.centerYAnchor.constraint(equalTo: navBar!.centerYAnchor).isActive = true
        
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        profileImageButton.rightAnchor.constraint(equalTo: navBar!.rightAnchor, constant: -20).isActive = true
        profileImageButton.centerYAnchor.constraint(equalTo: pageControl.stack!.centerYAnchor).isActive = true
        profileImageButton.heightAnchor.constraint(equalToConstant: navBar!.frame.height/1.5).isActive = true
        profileImageButton.widthAnchor.constraint(equalToConstant: navBar!.frame.height/1.5).isActive = true
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.rightAnchor.constraint(equalTo: profileImageButton.leftAnchor, constant: -20).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: pageControl.stack!.centerYAnchor).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: navBar!.frame.height/2).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: navBar!.frame.height/2).isActive = true
        
        newListButton.translatesAutoresizingMaskIntoConstraints = false
        newListButton.rightAnchor.constraint(equalTo: searchButton.leftAnchor, constant: -20).isActive = true
        newListButton.centerYAnchor.constraint(equalTo: pageControl.stack!.centerYAnchor).isActive = true
        newListButton.heightAnchor.constraint(equalToConstant: navBar!.frame.height/2).isActive = true
        newListButton.widthAnchor.constraint(equalToConstant: navBar!.frame.height/2).isActive = true
    }
    
    func setViewControllers() {
        let width = view.frame.width
        let height = view.frame.height
        let navBarHeight = navigationController?.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let viewControllers = [AllListsViewController(), UserListsViewController()]
        
        var index: Int = 0
        
        for viewController in viewControllers {
            addChildViewController(viewController)
            let originX: CGFloat = CGFloat(index) * width

            viewController.view.frame = CGRect(x: originX, y: 0, width: width, height: height - (navBarHeight! + statusBarHeight))
            scrollView.addSubview(viewController.view)
            viewController.didMove(toParentViewController: self)
            index += 1
        }
        pageControl.selectIndex(0)
        pageControl.deselectIndex(1)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        switch pageNumber {
        case 0:
            pageControl.selectIndex(0)
            pageControl.deselectIndex(1)
        default:
            pageControl.selectIndex(1)
            pageControl.deselectIndex(0)
        }
    }
    
    func selectedIndex(index: Int) {
        switch index {
        case 0:
            scrollView.setCurrentPage(position: 0)
            pageControl.deselectIndex(1)
        default:
            scrollView.setCurrentPage(position: 1)
            pageControl.deselectIndex(0)
        }
    }
}
