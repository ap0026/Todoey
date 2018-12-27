//
//  Item.swift
//  Todoey
//
//  Created by Agnius Pazecka on 24/12/2018.
//  Copyright © 2018 Agnius Pazecka. All rights reserved.
//

import Foundation

class Item : Encodable, Decodable {
    
    var name : String = ""
    var done : Bool = false
    
}
