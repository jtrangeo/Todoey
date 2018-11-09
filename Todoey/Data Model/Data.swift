//
//  Data.swift
//  Todoey
//
//  Created by Joseph Ng on 11/5/18.
//  Copyright © 2018 Jo Ng. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
