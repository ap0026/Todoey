//
//  Category.swift
//  Todoey
//
//  Created by Agnius Pazecka on 31/12/2018.
//  Copyright © 2018 Agnius Pazecka. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
