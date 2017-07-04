//
//  WebViewController.swift
//  MyLysts
//
//  Created by keith martin on 7/3/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    private let webView: UIWebView
    
    init(webView: UIWebView) {
        self.webView = webView
        super.init(nibName: nil, bundle: nil)
        view.addSubview(webView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackButton()
    }
    
    func setBackButton() {
        let navBarHeight = navigationController!.navigationBar.frame.height
        let buttonLeftMenu: UIButton = UIButton()
        buttonLeftMenu.setImage(UIImage(named: "back"), for: UIControlState())
        buttonLeftMenu.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        buttonLeftMenu.frame = CGRect(x: 0, y: 0, width: navBarHeight/2, height: navBarHeight/2)
        let barButton = UIBarButtonItem(customView: buttonLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func backButtonTapped(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
