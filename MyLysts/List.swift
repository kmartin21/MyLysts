//
//  List.swift
//  MyLysts
//
//  Created by keith martin on 7/3/17.
//  Copyright © 2017 Keith Martin. All rights reserved.
//

import Foundation

struct List {
    let id: String
    let title: String
    let description: String
    let imageUrl: String
    let lists: [DetailListItem] = []
}
