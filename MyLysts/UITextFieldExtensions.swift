//
//  UITextFieldExtensions.swift
//  MyLysts
//
//  Created by keith martin on 7/2/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = Color.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = Color.lightGrey.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
