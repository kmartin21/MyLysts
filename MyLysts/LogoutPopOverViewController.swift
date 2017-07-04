//
//  LogoutPopOverViewController.swift
//  MyLysts
//
//  Created by keith martin on 7/4/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import UIKit

class LogoutPopOverViewController: UIViewController {

    private let logoutButton: UIButton = UIButton(frame: .zero)
    var didLogout: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(Color.black, for: .normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        view.addSubview(logoutButton)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logout(sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        dismiss(animated: true, completion: nil)
        didLogout?()
    }

}
