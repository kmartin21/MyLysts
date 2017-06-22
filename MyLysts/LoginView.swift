//
//  LoginView.swift
//  MyLysts
//
//  Created by keith martin on 6/21/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import UIKit

class LoginView: UIView {

    private let logoImageView: UIImageView
    private let myLystsLabel: UILabel
    private let largeHeaderLabel: UILabel
    private let mediumHeaderLabel: UILabel
    private let smallHeaderLabel: UILabel
    let loginButton: UIButton
    
    override init(frame: CGRect) {
        logoImageView = UIImageView(frame: .zero)
        myLystsLabel = UILabel(frame: .zero)
        largeHeaderLabel = UILabel(frame: .zero)
        mediumHeaderLabel = UILabel(frame: .zero)
        smallHeaderLabel = UILabel(frame: .zero)
        loginButton = UIButton(frame: .zero)
        super.init(frame: frame)
        
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() {
        self.backgroundColor = .white
        
        logoImageView.image = UIImage(named: "app_icon")
        
        myLystsLabel.backgroundColor = .clear
        myLystsLabel.textColor = .black
        myLystsLabel.text = "MyLysts"
        myLystsLabel.font = UIFont(name: TextFont.normalBold, size: TextSize.bigger1)
        myLystsLabel.textAlignment = .center
        
        largeHeaderLabel.backgroundColor = .clear
        largeHeaderLabel.numberOfLines = 2
        largeHeaderLabel.adjustsFontSizeToFitWidth = true
        largeHeaderLabel.textColor = .black
        largeHeaderLabel.text = "Build Your Lists.\nLearn Something New."
        largeHeaderLabel.font = UIFont(name: TextFont.normalBold, size: TextSize.bigger4)
        largeHeaderLabel.textAlignment = .center
        
        mediumHeaderLabel.backgroundColor = .clear
        mediumHeaderLabel.numberOfLines = 2
        mediumHeaderLabel.adjustsFontSizeToFitWidth = true
        mediumHeaderLabel.textColor = Color.lightBlack
        mediumHeaderLabel.text = "Public & private nested lists of text, links, & images.\nCollaborate with others."
        mediumHeaderLabel.font = UIFont(name: TextFont.normalMedium, size: TextSize.bigger2)
        mediumHeaderLabel.textAlignment = .center
        
        smallHeaderLabel.backgroundColor = .clear
        smallHeaderLabel.numberOfLines = 0
        smallHeaderLabel.textColor = Color.grey
        smallHeaderLabel.text = "Login to start your lists!"
        smallHeaderLabel.font = UIFont(name: TextFont.normal, size: TextSize.small)
        smallHeaderLabel.textAlignment = .center
        
        loginButton.backgroundColor = UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitle("Login With Google", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: TextFont.normalMedium, size: TextSize.small)
        loginButton.layer.cornerRadius = 25
        loginButton.titleLabel?.textAlignment = .center
        loginButton.clipsToBounds = true
        
        self.addSubview(logoImageView)
        self.addSubview(myLystsLabel)
        self.addSubview(largeHeaderLabel)
        self.addSubview(mediumHeaderLabel)
        self.addSubview(smallHeaderLabel)
        self.addSubview(loginButton)
        
        addConstraints()
    }
    
    func addConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height/5).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: self.frame.width/10).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: self.frame.width/10).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        myLystsLabel.translatesAutoresizingMaskIntoConstraints = false
        myLystsLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10).isActive = true
        myLystsLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 20).isActive = true
        myLystsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        largeHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        largeHeaderLabel.topAnchor.constraint(equalTo: myLystsLabel.bottomAnchor, constant: 20).isActive = true
        largeHeaderLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 20).isActive = true
        largeHeaderLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        mediumHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        mediumHeaderLabel.topAnchor.constraint(equalTo: largeHeaderLabel.bottomAnchor, constant: 10).isActive = true
        mediumHeaderLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 20).isActive = true
        mediumHeaderLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        smallHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        smallHeaderLabel.topAnchor.constraint(equalTo: mediumHeaderLabel.bottomAnchor, constant: 10).isActive = true
        smallHeaderLabel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        smallHeaderLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.widthAnchor.constraint(equalToConstant: self.frame.width/1.5).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: smallHeaderLabel.bottomAnchor, constant: 20).isActive = true
    }
}
