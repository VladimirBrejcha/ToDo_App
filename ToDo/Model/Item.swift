//
//  Item.swift
//  ToDo
//
//  Created by Vladimir Korolev on 29/04/2019.
//  Copyright © 2019 Vladimir Brejcha. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var isDone = false
    @objc dynamic var dateCreated: Date?
  
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
