//
//  DetailListItem.swift
//  MyLysts
//
//  Created by keith martin on 7/3/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

struct DetailListItem {
    
    let url: String
    let title: String?
    let description: String?
    let imageUrl: String?
    
}

extension DetailListItem: JSONDecodable {
    
    init?(value: JSONDictionary, references: JSONDictionary) {
        guard let url = value["url"] as? String else { return nil }
        self.url = url
        self.title = value["title"] as? String
        self.description = value["description"] as? String
        self.imageUrl = value["imageUrl"] as? String
    }
}
