//
//  ViewController.swift
//  MyLysts
//
//  Created by keith martin on 6/22/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import UIKit

class AllListsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = false
        
        let logoutLabel = UIButton()
        logoutLabel.setTitleColor(.black, for: .normal)
        logoutLabel.setTitle("Logout", for: .normal)
        logoutLabel.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        view.addSubview(logoutLabel)
        
        logoutLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoutLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logoutButtonTapped(sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        
        let loginViewController = LoginViewController()
        self.navigationController?.setViewControllers([loginViewController], animated: true)
    }
}
