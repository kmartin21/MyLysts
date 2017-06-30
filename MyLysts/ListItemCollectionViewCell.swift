//
//  ListItemCollectionViewCell.swift
//  MyLysts
//
//  Created by keith martin on 6/28/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import UIKit

class ListItemCollectionViewCell: UICollectionViewCell {
    
    private let imageImageView: UIImageView
    private let titleLabel: UILabel
    private let descriptionLabel: UILabel
    private let authorLabel: UILabel
    private let numViewsLabel: UILabel
    private let numLinksLabel: UILabel
    private let numListsLabel: UILabel
    private let shareLabel: UILabel
    
    override init(frame: CGRect) {
        imageImageView = UIImageView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        descriptionLabel = UILabel(frame: .zero)
        authorLabel = UILabel(frame: .zero)
        numViewsLabel = UILabel(frame: .zero)
        numLinksLabel = UILabel(frame: .zero)
        numListsLabel = UILabel(frame: .zero)
        shareLabel = UILabel(frame: .zero)

        super.init(frame: frame)
        
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() {
        
        addConstraints()
    }
    
    func addConstraints() {
        
    }
}
