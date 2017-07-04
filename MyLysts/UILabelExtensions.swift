//
//  UILabelExtensions.swift
//  MyLysts
//
//  Created by keith martin on 7/3/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

extension UILabel {
    func requiredHeight(_ width:CGFloat = 0) -> CGFloat{
        var label:UILabel!
        if width == 0 {
            //if frame has been created with desired with don't pass in anything, size will be determined
            label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        } else {
            label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        }
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        return label.frame.height
    }
}
