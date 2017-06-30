//
//  PageControl.swift
//  MyLysts
//
//  Created by keith martin on 6/27/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import UIKit

protocol PageControlDelegate {
    func selectedIndex(index: Int)
}

class PageControl : NSObject {
    
    var stack : UIStackView? = nil
    var delegate : PageControlDelegate?
    
    init(titles: [String]) {
        let array = titles.map({ title -> UIButton in
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(Color.black, for: .selected)
            button.setTitleColor(Color.lightGrey, for: .normal)
            button.titleLabel?.font = TextFont.headingMedium
            return button
        })
        
        stack = UIStackView(arrangedSubviews: array)
        stack?.translatesAutoresizingMaskIntoConstraints = false
        stack?.spacing = 10
        stack?.distribution = .fillEqually
        stack?.alignment = .center
        
        super.init()
        
        array.forEach({ button in
            button.addTarget(self, action: #selector(selected(sender:)), for: .touchUpInside)
        })
    }
    
    func selectIndex(_ index:Int){
        var count = 0
        for button in (stack?.subviews)! as! [UIButton] {
            guard count == index else {
                count += 1
                continue
            }
            button.isSelected = true
            break
        }
    }
    
    func deselectIndex(_ index:Int){
        var count = 0
        for button in (stack?.subviews)! as! [UIButton] {
            guard count == index else {
                count += 1
                continue
            }
            button.isSelected = false
            break
        }
    }
    
    func selected(sender : UIButton){
        for button in (stack?.subviews)! as! [UIButton] {
            button.isSelected = button == sender
        }
        delegate?.selectedIndex(index: (stack?.subviews.index(of: sender))!)
    }
    
}
