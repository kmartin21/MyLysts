//
//  TextFont.swift
//  MyLysts
//
//  Created by keith martin on 6/21/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation
import UIKit

struct TextFont {
    static let normal: String = "HelveticaNeue"
    static let normalMedium: String = "HelveticaNeue-Medium"
    static let normalBold: String = "HelveticaNeue-Bold"
    static var inputNormal: UIFont = UIFont(name: TextFont.normal, size: TextSize.medium)!;
    
    static var headingSmall: UIFont = UIFont(name: TextFont.normalBold, size: TextSize.tinier1)!
    static var descriptionNormal: UIFont = UIFont(name: TextFont.normal, size: TextSize.small)!;
    static var descriptionSmall: UIFont = UIFont(name: TextFont.normal, size: TextSize.tiny)!;
    static var descriptionTiny: UIFont = UIFont(name: TextFont.normal, size: TextSize.tinier1)!;
    static var metaNormal: UIFont = UIFont(name: TextFont.normal, size: TextSize.tinier2)!;
    static var descriptionHeader:UIFont = UIFont(name: TextFont.normal, size: TextSize.normal)!
    static var metaSmallBold: UIFont = UIFont(name: TextFont.normalBold, size: TextSize.tinier3)!
    
    static func setHeadingBigger1(_ label: UILabel) {
        label.font = UIFont(name: TextFont.normalBold, size: TextSize.bigger1)
    }
    
    static func setHeadingBig(_ label: UILabel) {
        label.font = UIFont(name: TextFont.normalBold, size: TextSize.big)
    }
    
    static func setHeadingNormal(_ label: UILabel) {
        label.font = UIFont(name: TextFont.normalBold, size: TextSize.tiny)!
    }
    
    static func setHeadingSmall(_ label: UILabel) {
        label.font = headingSmall
    }
    
    static func setDescriptionHeader(_ label: UILabel) {
        label.font = descriptionHeader
    }
    
    static func setDescriptionBig(_ label: UILabel) {
        label.font = UIFont(name: TextFont.normal, size: TextSize.medium)!
    }
    
    static func setDescriptionMedium(_ label: UILabel) {
        label.font = UIFont(name: TextFont.normal, size: TextSize.normal)!
    }
    
    static func setDescriptionNormal(_ label: UILabel) {
        label.font = descriptionNormal
    }
    
    static func setDescriptionSmall(_ label: UILabel) {
        label.font = descriptionSmall
    }
    
    static func setDescriptionSmall(_ textView: UITextView) {
        textView.font = UIFont(name: TextFont.normal, size: TextSize.tiny)!
    }
    
    static func setDescriptionTiny(_ label: UILabel) {
        label.font = UIFont(name: TextFont.normal, size: TextSize.tinier1)!
    }
    
    static func setInputNormal(_ label: UITextField) {
        label.font = UIFont(name: TextFont.normal, size: TextSize.medium)!
    }
    
    static func setInputSmall(_ label: UITextField) {
        label.font = UIFont(name: TextFont.normal, size: TextSize.small)!
    }
    
    static func setMetaBig(_ label: UILabel) {
        label.font = UIFont(name: TextFont.normal, size: TextSize.tinier1)
    }
    
    static func setMetaNormal(_ label: UILabel) {
        label.font = metaNormal
    }
    
    static func setMetaNormalBold(_ label: UILabel) {
        label.font = UIFont(name: TextFont.normalBold, size: TextSize.tinier2)
    }
    
    static func setMetaSmallBold(_ label: UILabel) {
        label.font = metaSmallBold
    }
}

struct TextSize {
    static let bigger6: CGFloat = 34
    static let bigger5: CGFloat = 32
    static let bigger4: CGFloat = 30
    static let bigger3: CGFloat = 28
    static let bigger2: CGFloat = 26
    static let bigger1: CGFloat = 24
    static let big: CGFloat = 22
    static let medium: CGFloat = 20
    static let normal: CGFloat = 18
    static let small: CGFloat = 16
    static let tiny: CGFloat = 14
    static let tinier1: CGFloat = 12
    static let tinier2: CGFloat = 10
    static let tinier3: CGFloat = 8
}
