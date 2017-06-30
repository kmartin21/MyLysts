//
//  UIScrollViewExtensions.swift
//  MyLysts
//
//  Created by keith martin on 6/28/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

extension UIScrollView {
    
    func setCurrentPage(position: Int) {
        var frame = self.frame;
        frame.origin.x = frame.size.width * CGFloat(position)
        frame.origin.y = 0
        scrollRectToVisible(frame, animated: true)
    }
    
}
