//
//  UIButtonExtensions.swift
//  MyLysts
//
//  Created by keith martin on 7/3/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

extension UIButton {
    
    func createOvalButton() {
        self.layer.borderWidth = 1
        self.titleLabel?.font = UIFont(name: TextFont.normalMedium, size: TextSize.small)
        self.layer.cornerRadius = 20
        self.titleLabel?.textAlignment = .center
        self.clipsToBounds = true
    }
    
}
