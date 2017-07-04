//
//  DetailListItem.swift
//  MyLysts
//
//  Created by keith martin on 7/3/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

struct DetailListItem {
    
    let id: String
    let listId: String
    let url: String
    let title: String?
    let description: String?
    let imageUrl: String?
    
}

extension DetailListItem: JSONDecodable {
    
    init?(value: JSONDictionary, references: JSONDictionary) {
        guard let id = value["id"] as? String,
              let listId = value["listId"] as? String,
              let data = value["data"] as? JSONDictionary,
              let url = data["url"] as? String else { return nil }
        self.id = id
        self.listId = listId
        self.url = url
        self.title = value["title"] as? String
        self.description = value["description"] as? String
        self.imageUrl = value["imageUrl"] as? String
    }
}
