//
//  SearchViewModel.swift
//  MyLysts
//
//  Created by keith martin on 7/4/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

class SearchViewModel {
    
    private let apiClient: APIClient
    
    init() {
        apiClient = APIClient()
    }
    
    func searchLists(keyword: String, completion: @escaping ([ListItem]?, Error?) -> ()) {
        let resource = createLoadMoreResource(keyword: keyword)
        apiClient.load(resource: resource) { (dictionaries, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let values = dictionaries!["values"] as? [JSONDictionary] else {
                completion(nil, APIClientError.CouldNotDecodeJSON)
                return
            }
            let listItems = values.flatMap({ (dictionary) -> ListItem? in
                return ListItem(value: dictionary, references: dictionaries!["references"] as! JSONDictionary)
            })
            completion(listItems, error)
        }
    }
    
    private func createLoadMoreResource(keyword: String) -> Resource<JSONDictionary> {
        return Resource(url: URL(string: "http://www.mylysts.com/api/i/search/list/\(keyword)?apiKey=p8q937b32y2ef8sdyg&accessToken=\(User.currentUser!.getAccessToken())")!, parseJSON: { json in
            guard let dictionary = json as? JSONDictionary else { return nil }
            return dictionary
        })
    }
}
