//
//  HttpMethod.swift
//  MyLysts
//
//  Created by keith martin on 6/29/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

enum HttpMethod<Body> {
    case get
    case post(Body?)
    case delete
}

extension HttpMethod {
    var method: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .delete: return "DELETE"
        }
    }
    
    func map<B>(f: (Body) -> B) -> HttpMethod<B> {
        switch self {
        case .get: return .get
        case .post(let body):
            guard let body = body else {
                return .post(nil)
            }
            return .post(f(body))
        case .delete: return .delete
        }
        
    }
}
