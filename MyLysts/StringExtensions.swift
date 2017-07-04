//
//  StringExtensions.swift
//  MyLysts
//
//  Created by keith martin on 7/3/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

extension String {
    
    func isValidUrl() -> Bool {
        guard let url = URL(string: self) else {
                return false
        }
        return UIApplication.shared.canOpenURL(url)
    }

    
}
