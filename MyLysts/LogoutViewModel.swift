//
//  LogoutViewModel.swift
//  MyLysts
//
//  Created by keith martin on 7/4/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

class LogoutViewModel {
    private let apiClient: APIClient
    
    init() {
        apiClient = APIClient()
    }
    
    func logoutUser(completion: @escaping ((_ response: Any?, _ error: Error?) -> ())) {
        apiClient.load(resource: User.logout) { (result, error) in
            completion(result, error)
        }
    }
}

extension User {
    static let logout = Resource<JSONDictionary>(url: URL(string: "http://www.mylysts.com/api/i/user/\(User.currentUser!.getUserId())/mod/logout?apiKey=p8q937b32y2ef8sdyg&accessToken=\(User.currentUser!.getAccessToken())")!, method: .post(nil), parseJSON: { json in
        guard let dictionaries = json as? JSONDictionary else { return nil }
        return dictionaries
    })
}
