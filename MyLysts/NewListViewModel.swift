//
//  NewListViewModel.swift
//  MyLysts
//
//  Created by keith martin on 7/3/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

class NewListViewModel {
    
    private let apiClient: APIClient
    private let pagingParams: PagingParams
    
    init() {
        apiClient = APIClient()
        pagingParams = PagingParams()
    }
    
    func createNewList(listInfo: [String: String], completion: @escaping ((_ token: Any?, _ error: Error?) -> ())) {
        let resource = createListResource(listInfo: listInfo)
        apiClient.load(resource: resource) { (result, error) in
            completion(result, error)
        }
    }
    
    func addListItem(listId: String, listItemInfo: [String: String], completion: @escaping ((_ token: Any?, _ error: Error?) -> ())) {
        let resource = createListItemResource(listId: listId, listItemInfo: listItemInfo)
        apiClient.load(resource: resource) { (result, error) in
            completion(result, error)
        }
    }
    
    func fetchList(id: String, completion: @escaping ((_ token: Any?, _ error: Error?) -> ())) {
        let resource = createGetByIdResource(id: id)
        apiClient.load(resource: resource) { (list, error) in
            completion(list, error)
        }
    }
    
    private func createGetByIdResource(id: String) -> Resource<JSONDictionary> {
        let url = URL(string: "http://www.mylysts.com/api/i/list/v/\(id)?apiKey=p8q937b32y2ef8sdyg&accessToken=\(User.currentUser!.getAccessToken())")!
        print(url.absoluteString)
        return Resource(url: url, parseJSON: { json in
            guard let dictionaries = json as? JSONDictionary else { return nil }
            return dictionaries

        })
    }
    
    
    private func createListResource(listInfo: [String: String]) -> Resource<JSONDictionary> {
        let url = URL(string: "http://www.mylysts.com/api/i/list?apiKey=p8q937b32y2ef8sdyg&accessToken=\(User.currentUser!.getAccessToken())")!
        let dictionary = listInfo
        return Resource(url: url, method: .post(dictionary), parseJSON: { json in
            guard let dictionaries = json as? JSONDictionary else { return nil }
            return dictionaries
            
        })
    }
    
    private func createListItemResource(listId: String, listItemInfo: [String: String]) -> Resource<JSONDictionary> {
        let url = URL(string: "http://www.mylysts.com/api/i/list/\(listId)/mod/item?apiKey=p8q937b32y2ef8sdyg&accessToken=\(User.currentUser!.getAccessToken())")!
        let dictionary = listItemInfo
        return Resource(url: url, method: .post(dictionary), parseJSON: { json in
            guard let dictionaries = json as? JSONDictionary else { return nil }
            return dictionaries
            
        })
    }
    
}
