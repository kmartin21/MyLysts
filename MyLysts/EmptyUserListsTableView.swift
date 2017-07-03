//
//  EmptyUserListsTableView.swift
//  MyLysts
//
//  Created by keith martin on 7/2/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import UIKit

class EmptyUserListsTableView: UIView {
    
    private let createListButton: UIButton
    private let headerLabel: UILabel
    private let ideasHeaderLabel: UILabel
    private let ideasLabel: UILabel

    override init(frame: CGRect) {
        createListButton = UIButton(frame: .zero)
        headerLabel = UILabel(frame: .zero)
        ideasHeaderLabel = UILabel(frame: .zero)
        ideasLabel = UILabel(frame: .zero)
        super.init(frame: frame)
        
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createUI() {
        self.backgroundColor = Color.white
        
        createListButton.backgroundColor = Color.white
        createListButton.setTitleColor(Color.lightGrey, for: .normal)
        createListButton.layer.borderColor = Color.lightGrey.cgColor
        createListButton.layer.borderWidth = 1
        createListButton.setTitle("Create A List", for: .normal)
        createListButton.titleLabel?.font = UIFont(name: TextFont.normalMedium, size: TextSize.small)
        createListButton.layer.cornerRadius = 25
        createListButton.titleLabel?.textAlignment = .center
        createListButton.clipsToBounds = true
        addSubview(createListButton)
        
        headerLabel.backgroundColor = .clear
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.textColor = Color.lightGrey
        headerLabel.text = "Create a list of anything for the world to see."
        headerLabel.font = UIFont(name: TextFont.normal, size: TextSize.small)
        headerLabel.textAlignment = .left
        addSubview(headerLabel)
        
        ideasHeaderLabel.backgroundColor = .clear
        ideasHeaderLabel.textColor = Color.grey
        ideasHeaderLabel.text = "Here are some ideas:"
        ideasHeaderLabel.font = UIFont(name: TextFont.normalMedium, size: TextSize.small)
        ideasHeaderLabel.textAlignment = .left
        addSubview(ideasHeaderLabel)
        
        ideasLabel.backgroundColor = .clear
        ideasLabel.numberOfLines = 0
        ideasLabel.textColor = Color.lightGrey
        ideasLabel.text = "A list of places to eat in your favorite city.\nA list of your favorite websites.\nA list of potential housing spots.\nA list of vegan recipe sites.\nA list of vegetarian recipes.\nA list of grocery stores.\nA list of job applications.\nA list of college applications.\nA list of scholarship applications."
        ideasLabel.font = UIFont(name: TextFont.normal, size: TextSize.small)
        ideasLabel.textAlignment = .left
        addSubview(ideasLabel)
        
        addConstraints()
    }
    
    func addConstraints() {
        createListButton.translatesAutoresizingMaskIntoConstraints = false
        createListButton.widthAnchor.constraint(equalToConstant: self.frame.width/1.5).isActive = true
        createListButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        createListButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        createListButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 20).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerLabel.topAnchor.constraint(equalTo: createListButton.bottomAnchor, constant: 20).isActive = true
        
        ideasHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        ideasHeaderLabel.leftAnchor.constraint(equalTo: headerLabel.leftAnchor).isActive = true
        ideasHeaderLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 20).isActive = true
        ideasHeaderLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        ideasHeaderLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20).isActive = true
        
        ideasLabel.translatesAutoresizingMaskIntoConstraints = false
        ideasLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 20).isActive = true
        ideasLabel.leftAnchor.constraint(equalTo: ideasHeaderLabel.leftAnchor).isActive = true
        ideasLabel.topAnchor.constraint(equalTo: ideasHeaderLabel.bottomAnchor, constant: 20).isActive = true
    }
    
    func getCreateListButton() -> UIButton {
        return createListButton
    }
    
}
