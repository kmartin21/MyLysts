//
//  APIClient.swift
//  MyLysts
//
//  Created by keith martin on 6/29/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

enum APIClientError: Error {
    case CouldNotDecodeJSON
    case BadStatus(status: Int)
    case Other(NSError)
}

final class APIClient {
    private let session: URLSession
    
    init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.session = URLSession(configuration: configuration)
    }
    
    func load<T>(resource: Resource<T>, completion: @escaping ((T?, Error?) -> ())) {
        let request = URLRequest(resource: resource)
        self.session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(nil, APIClientError.Other(error as NSError))
            } else {
                guard let HTTPResponse = response as? HTTPURLResponse else {
                    fatalError("Couldn't get HTTP response")
                }
                
                if 200 ..< 300 ~= HTTPResponse.statusCode {
                    completion(resource.parse(data!), nil)
                }
                else {
                    completion(nil, APIClientError.BadStatus(status: HTTPResponse.statusCode))
                }
            }
        }.resume()
    }
}
