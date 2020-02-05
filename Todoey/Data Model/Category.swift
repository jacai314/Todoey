//
//  Category.swift
//  Todoey
//
//  Created by Jae Chang on 12/9/19.
//  Copyright © 2019 JACAI. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var backgroundColor : String?
    let items = List<Item>()
    
}
