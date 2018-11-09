//
//  Category.swift
//  Todoey
//
//  Created by Joseph Ng on 11/6/18.
//  Copyright © 2018 Jo Ng. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name: String = ""
    let items = List<Item>() //forward rel CAt-> Item
}
