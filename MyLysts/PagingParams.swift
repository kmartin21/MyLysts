//
//  PagingParams.swift
//  MyLysts
//
//  Created by keith martin on 7/1/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

class PagingParams {
    private var from: Int64
    private var limit: Int
    private var remainder: Int
    
    init() {
        from = -1
        limit = -1
        remainder = -1
    }
    
    func updateParams(pagingDict: JSONDictionary) {
        if let pagingParams = pagingDict["paging"] as? JSONDictionary {
            from = pagingParams["from"] as! Int64
            limit = pagingParams["limit"] as! Int
            remainder = pagingParams["remainder"] as! Int
        }
    }
    
    func canLoadMore() -> Bool {
        return remainder > 0
    }
    
    func getFrom() -> Int64 {
        return from
    }
    
    func getLimit() -> Int {
        return limit
    }
}
