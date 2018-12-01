//
//  Category.swift
//  Todoey
//
//  Created by Sergey Larkin on 2018/11/30.
//  Copyright © 2018 Sergey Larkin. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    let items = List<Item>()
}
