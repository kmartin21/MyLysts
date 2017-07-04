//
//  ListItemCollectionViewCell.swift
//  MyLysts
//
//  Created by keith martin on 6/28/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import UIKit
import Kingfisher

class ListItemTableViewCell: UITableViewCell {
    
    private let imageImageView: UIImageView
    private let titleLabel: UILabel
    private let descriptionLabel: UILabel
    private let authorLabel: UILabel
    private let numViewsLabel: UILabel
    private let numLinksLabel: UILabel
    private let numListsLabel: UILabel
    private let shareLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        imageImageView = UIImageView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        descriptionLabel = UILabel(frame: .zero)
        authorLabel = UILabel(frame: .zero)
        numViewsLabel = UILabel(frame: .zero)
        numLinksLabel = UILabel(frame: .zero)
        numListsLabel = UILabel(frame: .zero)
        shareLabel = UILabel(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageImageView.layer.cornerRadius = 3
        imageImageView.clipsToBounds = true
    }
    
    private func createUI() {
        contentView.backgroundColor = Color.white
        
        contentView.addSubview(imageImageView)
        
        titleLabel.font = TextFont.descriptionNormal
        titleLabel.textColor = Color.green
        contentView.addSubview(titleLabel)
        
        descriptionLabel.font = TextFont.descriptionSmall
        descriptionLabel.textColor = Color.grey
        descriptionLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(descriptionLabel)

        authorLabel.font = TextFont.descriptionTiny
        authorLabel.textColor = Color.lightGrey
        contentView.addSubview(authorLabel)

        numViewsLabel.font = TextFont.descriptionTiny
        numViewsLabel.textColor = Color.lightGrey
        contentView.addSubview(numViewsLabel)

        numLinksLabel.font = TextFont.descriptionTiny
        numLinksLabel.textColor = Color.lightGrey
        contentView.addSubview(numLinksLabel)

        numListsLabel.font = TextFont.descriptionTiny
        numListsLabel.textColor = Color.lightGrey
        contentView.addSubview(numListsLabel)
        
        addConstraints()
    }
    
    private func addConstraints() {
        imageImageView.translatesAutoresizingMaskIntoConstraints = false
        imageImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        imageImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        imageImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: imageImageView.rightAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageImageView.topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leftAnchor.constraint(equalTo: imageImageView.rightAnchor, constant: 10).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.leftAnchor.constraint(equalTo: imageImageView.rightAnchor, constant: 10).isActive = true
        authorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15).isActive = true
        authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        numViewsLabel.translatesAutoresizingMaskIntoConstraints = false
        numViewsLabel.leftAnchor.constraint(equalTo: authorLabel.rightAnchor, constant: 20).isActive = true
        numViewsLabel.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor).isActive = true
        
        numLinksLabel.translatesAutoresizingMaskIntoConstraints = false
        numLinksLabel.leftAnchor.constraint(equalTo: numViewsLabel.rightAnchor, constant: 20).isActive = true
        numLinksLabel.centerYAnchor.constraint(equalTo: numViewsLabel.centerYAnchor).isActive = true
        
        numListsLabel.translatesAutoresizingMaskIntoConstraints = false
        numListsLabel.leftAnchor.constraint(equalTo: numLinksLabel.rightAnchor, constant: 20).isActive = true
        numListsLabel.centerYAnchor.constraint(equalTo: numLinksLabel.centerYAnchor).isActive = true
    }
    
    func updateCell(listItem: ListItem) {
        if let imageURL = listItem.imageURL {
            let url = URL(string: imageURL)
            imageImageView.kf.setImage(with: url)
        }
        imageImageView.backgroundColor = Color.backgroundGrey
        titleLabel.text = listItem.title
        descriptionLabel.text = listItem.description
        authorLabel.text = "By \(listItem.author)"
        numViewsLabel.text = "\(listItem.numViews) Views"
        if let numLinks = listItem.numLinks {
            numLinksLabel.text = "\(numLinks) Links"
        } else {
            numLinksLabel.text = ""
        }
        if let numLists = listItem.numLists {
            numListsLabel.text = "\(numLists) Lists"
        } else {
            numListsLabel.text = ""
        }
    }
    
    func updateCell(listItem: DetailListItem) {
        if let imageURL = listItem.imageUrl {
            let url = URL(string: imageURL)
            imageImageView.kf.setImage(with: url)
        }
        imageImageView.backgroundColor = Color.backgroundGrey
        titleLabel.text = listItem.title
        descriptionLabel.text = listItem.description
        authorLabel.text = listItem.url
        numViewsLabel.removeFromSuperview()
        numLinksLabel.removeFromSuperview()
        numListsLabel.removeFromSuperview()
    }
}
