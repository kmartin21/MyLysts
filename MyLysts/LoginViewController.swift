//
//  ViewController.swift
//  MyLysts
//
//  Created by keith martin on 6/21/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import UIKit
import Whisper

class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    private var loginView: LoginView!
    private let viewModel: LoginViewModel
    
    init() {
        viewModel = LoginViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self

        createUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createUI() {
        loginView = LoginView(frame: view.frame)
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        view.addSubview(loginView)
    }
    
    func loginButtonTapped(sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            print(error.localizedDescription)
            return
        }
        let errorMessage = Murmur(title: "Could not sign user in", backgroundColor: UIColor.red, titleColor: Color.white, font: TextFont.descriptionSmall, action: nil)
        let accessToken = user.serverAuthCode!
        viewModel.loginUser(accessToken: accessToken) { (result, error) in
            if error == nil, let dictionary = result as? JSONDictionary {
                DispatchQueue.main.async {
                    User.currentUser = User(dictionary: dictionary)
                    self.dismiss(animated: true, completion: nil)
                    let pageViewController = PageViewController()
                    self.navigationController?.pushViewController(pageViewController, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    Whisper.show(whistle: errorMessage, action: .show(0.5))
                    GIDSignIn.sharedInstance().signOut()
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        navigationController?.popToViewController(viewController, animated: true)
    }
    
}

