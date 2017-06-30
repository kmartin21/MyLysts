//
//  Resource.swift
//  MyLysts
//
//  Created by keith martin on 6/29/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

struct Resource<A> {
    let url: URL
    let method: HttpMethod<Data>
    let parse: (Data) -> A?
}

extension Resource {
    init(url: URL, method: HttpMethod<Any> = .get, parseJSON: @escaping (Any) -> A?) {
        self.url = url
        self.method = method.map { json in
            try! JSONSerialization.data(withJSONObject: json, options: [])
        }
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
            return json.flatMap(parseJSON)
        }
    }
}

extension URLRequest {
    init<A>(resource: Resource<A>) {
        self.init(url: resource.url)
        httpMethod = resource.method.method
        addValue("application/json", forHTTPHeaderField: "Content-Type")
        addValue("application/json", forHTTPHeaderField: "Accept")
        if case let .post(data) = resource.method {
            httpBody = data
        }
    }
}
