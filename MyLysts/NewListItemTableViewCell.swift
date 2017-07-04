//
//  NewListItemTableViewCell.swift
//  MyLysts
//
//  Created by keith martin on 7/2/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import UIKit

class NewListItemTableViewCell: UITableViewCell {

    private let imageURLTextField: UITextField
    private let titleTextField: UITextField
    private let descriptionTextField: UITextField
    private let linkTextField: UITextField
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        imageURLTextField = UITextField(frame: .zero)
        titleTextField = UITextField(frame: .zero)
        descriptionTextField = UITextField(frame: .zero)
        linkTextField = UITextField(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        contentView.backgroundColor = Color.white
        
        linkTextField.setBottomBorder()
        linkTextField.attributedPlaceholder = NSAttributedString(string: "List Item Url - e.g. coolwebsite.com", attributes: [NSForegroundColorAttributeName : Color.lightGrey])
        linkTextField.textColor = Color.lightBlack
        contentView.addSubview(linkTextField)
        
        titleTextField.setBottomBorder()
        titleTextField.attributedPlaceholder = NSAttributedString(string: "List Item Title", attributes: [NSForegroundColorAttributeName : Color.lightGrey])
        titleTextField.textColor = Color.lightBlack
        contentView.addSubview(titleTextField)
        
        descriptionTextField.setBottomBorder()
        descriptionTextField.attributedPlaceholder = NSAttributedString(string: "List Item Description", attributes: [NSForegroundColorAttributeName : Color.lightGrey])
        descriptionTextField.textColor = Color.lightBlack
        contentView.addSubview(descriptionTextField)
        
        imageURLTextField.setBottomBorder()
        imageURLTextField.attributedPlaceholder = NSAttributedString(string: "Image Url - e.g. coolwebsite.com/image.png", attributes: [NSForegroundColorAttributeName : Color.lightGrey])
        imageURLTextField.textColor = Color.lightBlack
        contentView.addSubview(imageURLTextField)
        
        addConstraints()
    }
    
    private func addConstraints() {
        linkTextField.translatesAutoresizingMaskIntoConstraints = false
        linkTextField.widthAnchor.constraint(equalToConstant: contentView.frame.width - 20).isActive = true
        linkTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        linkTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        linkTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.widthAnchor.constraint(equalToConstant: contentView.frame.width - 20).isActive = true
        titleTextField.topAnchor.constraint(equalTo: linkTextField.bottomAnchor, constant: 20).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.widthAnchor.constraint(equalToConstant: contentView.frame.width - 20).isActive = true
        descriptionTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20).isActive = true
        descriptionTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        descriptionTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        imageURLTextField.translatesAutoresizingMaskIntoConstraints = false
        imageURLTextField.widthAnchor.constraint(equalToConstant: contentView.frame.width - 20).isActive = true
        imageURLTextField.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 20).isActive = true
        imageURLTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        imageURLTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    func getUrlText() -> String {
        return linkTextField.text!
    }
    
    func getTitleText() -> String {
        return titleTextField.text ?? ""
    }

    func getDescriptionText() -> String {
        return descriptionTextField.text ?? ""
    }
    
    func getImageUrlText() -> String {
        return imageURLTextField.text ?? ""
    }
}
