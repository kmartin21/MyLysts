//
//  User.swift
//  MyLysts
//
//  Created by keith martin on 6/29/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class User {
    static var currentUser: User?
    let username: String
    let profileImageUrl: String
    
    init?(dictionary: [String : Any]) {
        
        guard let accessToken = dictionary["accessToken"] as? JSONDictionary,
              let token = accessToken["token"] as? String,
              let user = dictionary["user"] as? JSONDictionary,
              let userId = user["id"] as? String,
              let username = user["username"] as? String,
              let profileImageURL = user["imageUrl"] as? String
              else { return nil }
        
        KeychainWrapper.standard.set(token, forKey:  KeychainKeys.accessToken)
        KeychainWrapper.standard.set(userId, forKey: KeychainKeys.userId)
        let defaults = UserDefaults.standard
        self.username = username
        self.profileImageUrl = profileImageURL
        defaults.set(username, forKey: DefaultsKeys.username)
        defaults.set(profileImageURL, forKey: DefaultsKeys.profileImageUrl)
    }
    
    init() {
        self.username = UserDefaults.standard.string(forKey: DefaultsKeys.username)!
        self.profileImageUrl = UserDefaults.standard.string(forKey: DefaultsKeys.profileImageUrl)!
    }
}


