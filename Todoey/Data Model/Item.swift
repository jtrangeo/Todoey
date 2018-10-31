//
//  Item.swift
//  Todoey
//
//  Created by Joseph Ng on 10/27/18.
//  Copyright © 2018 Jo Ng. All rights reserved.
//

import Foundation

class Item: Codable { //in order to be encodable, the properties below needs to not be custom
    
    
    var title: String = ""
    var done: Bool = false
}
