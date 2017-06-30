//
//  LoginViewModel.swift
//  MyLysts
//
//  Created by keith martin on 6/30/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    private let apiClient: APIClient
    
    init() {
        apiClient = APIClient()
    }
    
    func loginUser(accessToken: String, completion: @escaping ((_ token: Any?, _ error: Error?) -> ())) {
        let resource = createLoginResource(accessToken: accessToken)
        apiClient.load(resource: resource) { (result, error) in
            completion(result, error)
        }
    }
    
    private func createLoginResource(accessToken: String) -> Resource<JSONDictionary> {
        let url = URL(string: "http://www.mylysts.com/api/i/user/login/google?apiKey=p8q937b32y2ef8sdyg")!
        let dictionary = ["code": accessToken]
        return Resource(url: url, method: .post(dictionary), parseJSON: { json in
            guard let dictionaries = json as? JSONDictionary else { return nil }
            return dictionaries
        })
    }
}
