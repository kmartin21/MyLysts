//
//  DetailListViewModel.swift
//  MyLysts
//
//  Created by keith martin on 7/3/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

class DetailListViewModel {
    
    private let apiClient: APIClient
    private let pagingParams: PagingParams
    
    init() {
        apiClient = APIClient()
        pagingParams = PagingParams()
    }
    
    func fetchDetailList(id: String, completion: @escaping ([DetailListItem]?, Error?, Bool) -> ()) {
        let resource = createInitialLoadMoreResource(id: id)
        apiClient.load(resource: resource) { (dictionaries, error) in
            guard error == nil else {
                completion(nil, error, self.pagingParams.canLoadMore())
                return
            }
            let listItems = dictionaries!["listItems"] as! JSONDictionary
            guard let values = listItems["values"] as? [JSONDictionary] else {
                completion(nil, APIClientError.CouldNotDecodeJSON, self.pagingParams.canLoadMore())
                return
            }
            self.pagingParams.updateParams(pagingDict: listItems)
            let items = values.flatMap({ (dictionary) -> DetailListItem? in
                return DetailListItem(value: dictionary["data"] as! JSONDictionary, references: listItems["references"] as! JSONDictionary)
            })
            completion(items, error, self.pagingParams.canLoadMore())
        }
    }
    
    private func createInitialLoadMoreResource(id: String) -> Resource<JSONDictionary> {
        
        return Resource(url: URL(string: "http://www.mylysts.com/api/i/list/\(id)/v/items?apiKey=p8q937b32y2ef8sdyg&accessToken=\(User.currentUser!.getAccessToken())")!, parseJSON: { json in
            guard let dictionary = json as? JSONDictionary else { return nil }
            return dictionary
        })
    }
    
    
    private func createDetailListResource(id: String) -> Resource<JSONDictionary> {
        
        return Resource(url: URL(string: "http://www.mylysts.com/api/i/list/\(id)/v/items?apiKey=p8q937b32y2ef8sdyg&accessToken=\(User.currentUser!.getAccessToken())&limit=\(pagingParams.getLimit())&from=\(pagingParams.getFrom())&bpa=false")!, parseJSON: { json in
            print("http://www.mylysts.com/api/i/list/\(id)/v/items?apiKey=p8q937b32y2ef8sdyg&accessToken=\(User.currentUser!.getAccessToken())&limit=\(self.pagingParams.getLimit())&from=\(self.pagingParams.getFrom())&bpa=false")
            guard let dictionary = json as? JSONDictionary else { return nil }
            return dictionary
        })
    }
}
