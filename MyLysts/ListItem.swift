//
//  ListItem.swift
//  MyLysts
//
//  Created by keith martin on 6/28/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

struct ListItem {
    
    fileprivate let image: UIImage?
    fileprivate let title: String
    fileprivate let description: String
    fileprivate let author: String
    fileprivate let numViews: Int
    fileprivate let numLinks: Int?
    fileprivate let numLists: Int?
    
}

extension ListItem: JSONDecodable {
    
    init?(dictionary: JSONDictionary) {
        guard let values = dictionary["values"] as? JSONDictionary,
            let userId = values["userId"] as? String,
            let references = dictionary["references"] as? JSONDictionary,
            let users = references["users"] as? JSONDictionary,
            let itemCounts = dictionary["itemCounts"] as? JSONDictionary else { return nil }
        
        self.image = UIImage()
        self.title = values["title"] as? String ?? ""
        self.description = values["description"] as? String ?? ""
        self.author = (users[userId]! as! JSONDictionary)["username"] as! String
        self.numViews = values["numViews"] as! Int
        self.numLinks = itemCounts["numLinks"] as? Int
        self.numLists = itemCounts["numViews"] as? Int
    }
    
}

extension ListItem {
    static let all = Resource<[ListItem]>(url: URL(string: "http://www.mylysts.com/api/i/list/public?apiKey=p8q937b32y2ef8sdyg&accessToken=")!, parseJSON: { json in
        guard let dictionaries = json as? [JSONDictionary] else { return nil }
        return dictionaries.flatMap(ListItem.init)
    })
}
