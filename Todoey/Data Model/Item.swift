//
//  Item.swift
//  Todoey
//
//  Created by Jae Chang on 12/9/19.
//  Copyright © 2019 JACAI. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    @objc dynamic var backgroundColor : String?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
