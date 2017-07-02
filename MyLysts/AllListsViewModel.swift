//
//  AllListsViewModel.swift
//  MyLysts
//
//  Created by keith martin on 6/30/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

class AllListsViewModel {
    
    private let apiClient: APIClient
    private let pagingParams: PagingParams
    
    init() {
        apiClient = APIClient()
        pagingParams = PagingParams()
    }
    
    func fetchPublicLists(completion: @escaping ([ListItem]?, Error?, Bool) -> ()) {
        apiClient.load(resource: ListItem.all) { (dictionaries, error) in
            guard error == nil else {
                completion(nil, error, self.pagingParams.canLoadMore())
                return
            }
            guard let values = dictionaries!["values"] as? [JSONDictionary] else {
                completion(nil, APIClientError.CouldNotDecodeJSON, self.pagingParams.canLoadMore())
                return
            }
            self.pagingParams.updateParams(pagingDict: dictionaries!)
            let listItems = values.flatMap({ (dictionary) -> ListItem? in
                return ListItem(value: dictionary, references: dictionaries!["references"] as! JSONDictionary)
            })
            completion(listItems, error, self.pagingParams.canLoadMore())
        }
    }
    
   func loadMorePublicLists(completion: @escaping ([ListItem]?, Error?, Bool) -> ()) {
        let resource = createLoadMoreResource()
        apiClient.load(resource: resource) { (dictionaries, error) in
            guard error == nil else {
                completion(nil, error, self.pagingParams.canLoadMore())
                return
            }
            guard let values = dictionaries!["values"] as? [JSONDictionary] else {
                completion(nil, APIClientError.CouldNotDecodeJSON, self.pagingParams.canLoadMore())
                return
            }
            self.pagingParams.updateParams(pagingDict: dictionaries!)
            let listItems = values.flatMap({ (dictionary) -> ListItem? in
                return ListItem(value: dictionary, references: dictionaries!["references"] as! JSONDictionary)
            })
            completion(listItems, error, self.pagingParams.canLoadMore())
        }
    }
    
    private func createLoadMoreResource() -> Resource<JSONDictionary>{
        return Resource(url: URL(string: "http://www.mylysts.com/api/i/list/public?apiKey=p8q937b32y2ef8sdyg&accessToken=5949be124090eead3193427d-dfd7de53f86fd3109fba46bb06aa0831&limit=\(pagingParams.getLimit())&from=\(pagingParams.getFrom())")!, parseJSON: { json in
            guard let dictionary = json as? JSONDictionary else { return nil }
            return dictionary
        })
    }
}

extension ListItem {
    static let all = Resource<JSONDictionary>(url: URL(string: "http://www.mylysts.com/api/i/list/public?apiKey=p8q937b32y2ef8sdyg&accessToken=")!, parseJSON: { json in
        guard let dictionaries = json as? JSONDictionary else { return nil }
        return dictionaries
    })
}
