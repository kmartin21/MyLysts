//
//  JSONDecodable.swift
//  MyLysts
//
//  Created by keith martin on 6/29/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]

protocol JSONDecodable {
    init?(value: JSONDictionary, references: JSONDictionary)
}
