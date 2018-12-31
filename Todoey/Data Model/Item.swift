//
//  Item.swift
//  Todoey
//
//  Created by Agnius Pazecka on 31/12/2018.
//  Copyright © 2018 Agnius Pazecka. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: NSDate?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
