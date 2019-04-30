//
//  Category.swift
//  ToDo
//
//  Created by Vladimir Korolev on 29/04/2019.
//  Copyright © 2019 Vladimir Brejcha. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    @objc dynamic var backgroundColor = String()
    let items = List<Item>()
    
}
