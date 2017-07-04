//
//  PageViewController.swift
//  MyLysts
//
//  Created by keith martin on 6/27/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import UIKit
import Kingfisher

class PageViewController: UIViewController, UIScrollViewDelegate, PageControlDelegate, UIPopoverPresentationControllerDelegate {
    
    private let pageControl: PageControl
    private var scrollView: UIScrollView
    private let newListButton: UIButton
    private let searchButton: UIButton
    private let profileImageButton: UIButton
    private let viewControllers = [AllListsViewController(), UserListsViewController()]

    init() {
        pageControl = PageControl(titles: ["All", "Mine"])
        pageControl.stack?.tag = 1
        scrollView = UIScrollView()
        newListButton = UIButton(frame: .zero)
        newListButton.tag = 1
        searchButton = UIButton(frame: .zero)
        searchButton.tag = 1
        profileImageButton = UIButton(frame: .zero)
        profileImageButton.tag = 1
        
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
        
        let _ = navigationController?.navigationBar.subviews.map({ view in
            if view.tag == 1 {
                view.isHidden = false
            }
        })
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func createUI() {
        view.backgroundColor = Color.white
        
        scrollView.panGestureRecognizer.delaysTouchesBegan = true
        scrollView.canCancelContentTouches = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        view.addSubview(scrollView)

        newListButton.setImage(UIImage(named: "new_list"), for: .normal)
        newListButton.addTarget(self, action: #selector(newListButtonTapped), for: .touchUpInside)
        
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        profileImageButton.kf.setImage(with: URL(string: User.currentUser!.profileImageUrl), for: .normal)
        profileImageButton.imageView?.contentMode = .scaleAspectFit
        profileImageButton.layer.cornerRadius = 0.5 * (navigationController!.navigationBar.frame.height/1.5)
        profileImageButton.clipsToBounds = true
        profileImageButton.addTarget(self, action: #selector(profileImageButtonTapped), for: .touchUpInside)
        
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
    
    func profileImageButtonTapped() {
        
    }
    
    func newListButtonTapped() {
        let newListVC = NewListViewController()
        present(newListVC, animated: true, completion: nil)
        let userListsVC = viewControllers[1] as! UserListsViewController
        newListVC.didDismiss = { _ in
            userListsVC.refreshList()
        }
    }
    
    func searchButtonTapped() {
        let searchVC = SearchViewController(style: .plain)
        present(searchVC, animated: true, completion: nil)
        searchVC.selectedList = { listItem in
            let detailListVC = DetailListViewController(currentUserOwns: listItem.currentUserOwns, list: listItem)
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(detailListVC, animated: true)
            }
        }
    }
}

extension UITableView {
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        super.touchesBegan(touches, with: event)
        super.touchesEnded(touches, with: event)
    }
}
