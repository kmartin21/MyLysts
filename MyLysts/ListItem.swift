//
//  ListItem.swift
//  MyLysts
//
//  Created by keith martin on 6/28/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

struct ListItem {
    
    let imageURL: String?
    let privacy: String
    let id: String
    let currentUserOwns: Bool
    let title: String
    let description: String
    let author: String
    let numViews: Int
    let numLinks: Int?
    let numLists: Int?
    
}

extension ListItem: JSONDecodable {
    
    init?(value: JSONDictionary, references: JSONDictionary) {
        guard let id = value["id"] as? String,
            let privacy = value["privacy"] as? String,
            let userId = value["userId"] as? String,
            let users = references["users"] as? JSONDictionary,
            let itemCounts = value["itemCounts"] as? JSONDictionary else { return nil }
        
        self.id = id
        self.privacy = privacy
        self.currentUserOwns = userId == User.currentUser?.getUserId()
        self.imageURL = value["imageUrl"] as? String
        self.title = value["title"] as? String ?? ""
        self.description = value["description"] as? String ?? ""
        self.author = (users[userId]! as! JSONDictionary)["username"] as! String
        self.numViews = value["numViews"] as! Int
        self.numLinks = itemCounts["links"] as? Int
        self.numLists = itemCounts["lists"] as? Int
    }
}
