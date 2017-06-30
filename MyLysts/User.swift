//
//  User.swift
//  MyLysts
//
//  Created by keith martin on 6/29/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

class User {
    public static var currentUser: User?
    
    public let username: String
    
    public init?(dictionary: [String : Any]) {
        
        guard let username = dictionary["username"] as? String
            else { return nil }
        
        self.username = username
        
        let defaults = UserDefaults.standard
        defaults.set(username, forKey: DefaultsKeys.username)
    }
}

extension User {
    static let login = Resource<[ListItem]>(url: URL(string: "http://www.mylysts.com/api/i/user/login/google?apiKey=p8q937b32y2ef8sdyg")!, parseJSON: { json in
        guard let dictionaries = json as? [JSONDictionary] else { return nil }
        return dictionaries.flatMap(ListItem.init)
    })
}
