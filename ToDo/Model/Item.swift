//
//  Item.swift
//  ToDo
//
//  Created by Vladimir Korolev on 26/04/2019.
//  Copyright © 2019 Vladimir Brejcha. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {
    var title = ""
    var isDone = false
}
