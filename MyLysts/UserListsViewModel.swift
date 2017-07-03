//
//  UserListsViewModel.swift
//  MyLysts
//
//  Created by keith martin on 7/2/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class UserListsViewModel {
    
    private let apiClient: APIClient
    private let pagingParams: PagingParams
    
    init() {
        apiClient = APIClient()
        pagingParams = PagingParams()
    }
    
    func fetchCurrentUserLists(loadMore: Bool, completion: @escaping ([ListItem]?, Error?, Bool) -> ()) {
        let resource: Resource<JSONDictionary>!
        if loadMore {
            resource = createLoadMoreResource()
        } else {
            resource = ListItem.userAll
        }
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
    
    private func createLoadMoreResource() -> Resource<JSONDictionary> {
        return Resource(url: URL(string: "http://www.mylysts.com/api/i/user/\(User.currentUser!.getUserId())/v/lists?apiKey=p8q937b32y2ef8sdyg&accessToken=\(User.currentUser!.getAccessToken())&bpa=false&limit=\(pagingParams.getLimit())&from=\(pagingParams.getFrom())")!, parseJSON: { json in
            guard let dictionary = json as? JSONDictionary else { return nil }
            return dictionary
        })
    }
}

extension ListItem {
    static let userAll = Resource<JSONDictionary>(url: URL(string: "http://www.mylysts.com/api/i/user/\(KeychainWrapper.standard.string(forKey: KeychainKeys.userId)!)/v/lists?apiKey=p8q937b32y2ef8sdyg&accessToken=\(KeychainWrapper.standard.string(forKey: KeychainKeys.accessToken)!)&bpa=false")!, parseJSON: { json in
        guard let dictionaries = json as? JSONDictionary else { return nil }
        return dictionaries
    })
}
